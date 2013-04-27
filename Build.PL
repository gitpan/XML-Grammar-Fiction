
use strict;
use warnings;

use Module::Build 0.3601;
use lib qw{inc}; use XML::Grammar::Builder;

my %module_build_args = (
  "build_requires" => {
    "Config" => 0,
    "File::Find" => 0,
    "File::Temp" => 0,
    "Module::Build" => "0.3601",
    "Test::More" => 0,
    "Test::XML::Ordered" => 0,
    "parent" => 0,
    "utf8" => 0
  },
  "configure_requires" => {
    "ExtUtils::MakeMaker" => "6.30",
    "Module::Build" => "0.3601"
  },
  "dist_abstract" => "CPAN distribution implementing an XML grammar\nand a lightweight markup language for stories, novels and other fiction.",
  "dist_author" => [
    "Shlomi Fish <shlomif\@cpan.org>"
  ],
  "dist_name" => "XML-Grammar-Fiction",
  "dist_version" => "0.12.5",
  "license" => "mit",
  "module_name" => "XML::Grammar::Fiction",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
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
    "MooX::late" => "0.010",
    "XML::LibXML" => 0,
    "XML::LibXSLT" => 0,
    "XML::Writer" => 0,
    "autodie" => 0,
    "base" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "script_files" => []
);


my $build = XML::Grammar::Builder->new(%module_build_args);

$build->create_build_script;
