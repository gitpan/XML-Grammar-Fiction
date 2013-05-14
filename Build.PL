
use strict;
use warnings;

use Module::Build 0.3601;
use lib qw{inc}; use XML::Grammar::Builder;

my %module_build_args = (
  "build_requires" => {
    "Module::Build" => "0.3601"
  },
  "configure_requires" => {
    "Module::Build" => "0.3601"
  },
  "dist_abstract" => "CPAN distribution implementing an XML grammar\nand a lightweight markup language for stories, novels and other fiction.",
  "dist_author" => [
    "Shlomi Fish <shlomif\@cpan.org>"
  ],
  "dist_name" => "XML-Grammar-Fiction",
  "dist_version" => "0.14.6",
  "license" => "mit",
  "module_name" => "XML::Grammar::Fiction",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "Carp" => 0,
    "Exception::Class" => 0,
    "Exporter" => 0,
    "File::ShareDir" => 0,
    "File::Spec" => 0,
    "Getopt::Long" => 0,
    "HTML::Entities" => 0,
    "List::MoreUtils" => 0,
    "List::Util" => 0,
    "MooX" => 0,
    "MooX::late" => "0.010",
    "XML::GrammarBase::Role::RelaxNG" => "v0.2.2",
    "XML::GrammarBase::Role::XSLT" => "v0.2.2",
    "XML::LibXML" => 0,
    "XML::LibXSLT" => 0,
    "XML::Writer" => 0,
    "autodie" => 0,
    "base" => 0,
    "perl" => "5.014",
    "strict" => 0,
    "warnings" => 0
  },
  "script_files" => [],
  "test_requires" => {
    "Config" => 0,
    "File::Find" => 0,
    "File::Temp" => 0,
    "Test::More" => 0,
    "Test::XML::Ordered" => "v0.0.5",
    "parent" => 0,
    "utf8" => 0
  }
);


unless ( eval { Module::Build->VERSION(0.4004) } ) {
  my $tr = delete $module_build_args{test_requires};
  my $br = $module_build_args{build_requires};
  for my $mod ( keys %$tr ) {
    if ( exists $br->{$mod} ) {
      $br->{$mod} = $tr->{$mod} if $tr->{$mod} > $br->{$mod};
    }
    else {
      $br->{$mod} = $tr->{$mod};
    }
  }
}

my $build = XML::Grammar::Builder->new(%module_build_args);

$build->create_build_script;
