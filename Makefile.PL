
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "CPAN distribution implementing an XML grammar\nand a lightweight markup language for stories, novels and other fiction.",
  "AUTHOR" => "Shlomi Fish <shlomif\@cpan.org>",
  "BUILD_REQUIRES" => {
    "Config" => 0,
    "File::Find" => 0,
    "File::Temp" => 0,
    "Module::Build" => "0.3601",
    "Test::More" => 0,
    "Test::XML::Ordered" => 0,
    "parent" => 0,
    "utf8" => 0
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30",
    "Module::Build" => "0.3601"
  },
  "DISTNAME" => "XML-Grammar-Fiction",
  "EXE_FILES" => [],
  "LICENSE" => "mit",
  "NAME" => "XML::Grammar::Fiction",
  "PREREQ_PM" => {
    "Carp" => 0,
    "Data::Dumper" => 0,
    "Exception::Class" => 0,
    "Exporter" => 0,
    "File::ShareDir" => 0,
    "File::Spec" => 0,
    "Getopt::Long" => 0,
    "HTML::Entities" => 0,
    "List::MoreUtils" => 0,
    "List::Util" => 0,
    "MooX" => 0,
    "XML::LibXML" => 0,
    "XML::LibXSLT" => 0,
    "XML::Writer" => 0,
    "autodie" => 0,
    "base" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "VERSION" => "0.12.0",
  "test" => {
    "TESTS" => "t/*.t t/base/*.t t/fiction/*.t t/screenplay/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



