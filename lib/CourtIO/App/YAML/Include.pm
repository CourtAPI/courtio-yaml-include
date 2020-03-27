package CourtIO::App::YAML::Include;
# ABSTRACT: YAML Include processor
$CourtIO::App::YAML::Include::VERSION = '0.01';
use strict;
use warnings;

use Moo;
use MooX::Cmd;
use MooX::Options;
use CourtIO::YAML::PP;
use File::Spec;
use Fatal 'open';

option file => (
  is       => 'ro',
  format   => 's',
  required => 1,
  short    => 'f',
  doc      => 'The YAML file to process'
);

option include => (
  is         => 'ro',
  format     => 's@',
  repeatable => 1,
  short      => 'I',
  doc        => 'Include directories'
);

option output => (
  is      => 'ro',
  format  => 's',
  default => sub { '-' },
  short   => 'o',
  doc     => 'outfile, default is to print to stdout'
);

sub execute {
  my $self = shift;

  # Make include dirs absolute
  my @include_dirs = map { File::Spec->rel2abs($_) } $self->include->@*;

  my $yaml_pp = CourtIO::YAML::PP->new(paths => \@include_dirs);

  my $data = $yaml_pp->load_file($self->file);

  my $yaml_string = $yaml_pp->dump_string($data);

  if ($self->output eq '-') {
    print $yaml_string;
  }
  else {
    open my $outfh, '>', $self->output;
    print $outfh $yaml_string;
    close $outfh;
  }
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

CourtIO::App::YAML::Include - YAML Include processor

=head1 VERSION

version 0.01

=head1 AUTHOR

CourtAPI Team <support@courtapi.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by CourtAPI.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
