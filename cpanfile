requires "Fatal" => "0";
requires "File::Basename" => "0";
requires "File::Slurp" => "0";
requires "File::Spec" => "0";
requires "JSON::XS" => "0";
requires "Log::Log4perl" => "0";
requires "Log::Log4perl::Appender::ScreenColoredLevels" => "0";
requires "Moo" => "0";
requires "MooX::Cmd" => "0";
requires "MooX::Options" => "0";
requires "YAML::PP" => "0.021";
requires "YAML::PP::Common" => "0";
requires "namespace::clean" => "0";
requires "parent" => "0";
requires "perl" => "5.006";
requires "strict" => "0";
requires "strictures" => "2";
requires "warnings" => "0";

on 'test' => sub {
  requires "File::Spec" => "0";
  requires "IO::Handle" => "0";
  requires "IPC::Open3" => "0";
  requires "Test::More" => "0.94";
  requires "perl" => "5.006";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
  requires "perl" => "5.006";
};

on 'develop' => sub {
  requires "Test::Pod" => "1.41";
};
