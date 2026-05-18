package Devel::CheckLib;
use Exporter; our @ISA = ('Exporter'); our @EXPORT = qw(check_lib check_lib_or_exit assert_lib);
sub check_lib { return 1; }
sub check_lib_or_exit { return 1; }
sub assert_lib { return 1; }
1;
