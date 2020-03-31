package CourtIO::YAML::PP;

# ABSTRACT: YAML::PP with CourtIO::YAML::PP::Schema::Include

use strict;
use warnings;

use parent 'YAML::PP';

use YAML::PP::Common;
use CourtIO::YAML::PP::Schema::Include;

# extend new() to auto register CourtIO::YAML::PP::Schema::Include
sub new {
  my ($class, %args) = @_;

  my $include = CourtIO::YAML::PP::Schema::Include->new(%args);

  my $self = $class->SUPER::new(
    schema   => ['JSON', $include],
    boolean  => 'JSON::PP',
    preserve => YAML::PP::Common->PRESERVE_ORDER
  );

  $include->yaml_pp($self);

  return $self;
}

1;
