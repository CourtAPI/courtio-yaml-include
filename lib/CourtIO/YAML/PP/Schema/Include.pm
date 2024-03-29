package CourtIO::YAML::PP::Schema::Include;

# ABSTRACT: YAML Include Schema For CourtIO::YAML::PP

use Moo;
use strictures 2;
use namespace::clean;

use File::Slurp 'read_file';
use File::Basename 'dirname';
use Log::Log4perl ':easy';

has paths => (
  is      => 'ro',
  default => sub { [] }
);

has loader => (
  is  => 'ro',
  default => sub { \&default_loader }
);

has last_includes => (
  is      => 'ro',
  default => sub { [] }
);

has cached => (
  is      => 'ro',
  default => sub { {} }
);

has yaml_pp => (
  is       => 'rw',
  weak_ref => 1
);

sub register {
  my ( $self, %args ) = @_;

  $args{schema}->add_resolver(
    tag      => '!include',
    match    => [ all => sub { $self->include( @_ ) } ],
    implicit => 0,
  );
}

sub include {
  my ($self, $constructor, $event) = @_;

  my $yaml_pp = $self->yaml_pp;
  my @search_paths = $self->paths->@*;

  if ($self->last_includes->@*) {
    my $last_path = $self->last_includes->[-1];

    push @search_paths, $last_path;
  }
  elsif ($yaml_pp->loader->parser->reader->isa('YAML::PP::Reader::File')) {
    # we are in the top-level, and this is a file reader, so look into the
    # original YAML::PP instance to figure out the file that we loaded
    my $dirname = dirname( $yaml_pp->loader->filename );

    push @search_paths, $dirname;
  }

  my $filename = $event->{value};
  DEBUG 'Current file: ', $filename;
  TRACE Data::Dumper::Dumper($event);

  my @paths = File::Spec->splitdir($filename);

  my $fullpath;

  for my $candidate (@search_paths) {
    my $test = File::Spec->catfile( $candidate, @paths );
    TRACE 'Candidate filename: ', $test;

    if (-e $test) {
      $fullpath = $test;
      last;
    }
  }

  Carp::croak "File '$filename' not found" unless defined $fullpath;

  DEBUG 'Found file at: ', $fullpath;

  if ($self->cached->{ $fullpath }++) {
    Carp::croak "Circular include '$fullpath'";
  }

  push $self->last_includes->@*, dirname($fullpath);

  # We need a new object because we are still in the parsing and
  # constructing process
  my $clone = $yaml_pp->clone;

  my ($data) = $self->loader->($clone, $fullpath);

  pop $self->last_includes->@*;

  unless (--$self->cached->{ $fullpath }) {
    delete $self->{cached}->{ $fullpath };
  }

  return $data;
}

sub default_loader {
  my ( $yaml_pp, $filename ) = @_;

  if ( $filename =~ /\.(?:xml|md|txt)$/ ) {
    # These files are not YAML so just read them as strings
    return scalar read_file( $filename );
  }
  else {
    # parse and return yaml files
    return $yaml_pp->load_file( $filename );
  }
}

1;
