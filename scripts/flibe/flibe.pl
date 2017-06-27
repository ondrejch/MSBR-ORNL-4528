#!/usr/bin/perl -w
# 
# Calculates FLiBe-U salt density depending on U mole%

#use strict; use warnings;
no warnings 'experimental::smartmatch';
use feature qw/switch/;
use Math::Trig ':pi'; 			# use Math::Trig; # http://perldoc.perl.org/Math/Trig.html
use Chemistry::Isotope ':all';
&InitElements; 				# initializes %ELEMENTS 
my $twopi=pi2;

$saltmatlib='.{lib}';

$myUvariation = 0.9;        # relative change uranium load

$myUF4_mole = 0.002*$myUvariation; # nominal is 0.2 mole %
$U234_and_3 = 0.140649 + 1.265844; # u234 + u233
$U233fract = 1.265844/$U234_and_3;
$U234fract = 0.140649/$U234_and_3;

my @matsalt=();
my $flibeUdens = -1;

&FlibeDens;
&SaltFlibe;


print("% LiF-BeF2-UF4 (68.5-31.3-0.2 mole%)\n");
printf("mat FLiBeU -%9.7f tmp 973.0\n", $flibeUdens);
print ("rgb 130 32 144\n");
print @matsalt;


#
#------------------- subs
#

sub FlibeDens {
    $flibeUdens = 0.108087*$myUF4_mole*100.0 + 2.01272;
    print "Flibe desnity with ",$myUF4_mole," U mole fraction [g/cm3] = ", $flibeUdens, "\n";        
}

sub SaltFlibe {
  my $atomicmassBe = 9.0121831;
  my $li7enr   = 0.99995;               # Li7 enrichment
  my $mLimole = $li7enr * isotope_mass(7,3)     # molar mass of Li
        + (1. - $li7enr) * isotope_mass(6,3);
  my $fLiFmole = 0.685;
  my $fBeFmole = 0.313;
  my $fUF4mole = $myUF4_mole;		# molar fraction of UF4 in the salt
  my $mUmole   =  $U233fract * isotope_mass(233, 92) 	# molar mass of U
	           +  $U234fract * isotope_mass(234, 92);
  my $mBemole  = $atomicmassBe; 				# hack
  my $mFmole   = isotope_mass(19,9);
  my $Mmole    = 
	 $fLiFmole*$mLimole  + $fBeFmole*$mBemole + $fUF4mole*$mUmole + 
   ($fLiFmole+4.*$fUF4mole + 2.*$fBeFmole)*$mFmole;
  
  my $wfLi7    = $fLiFmole * $li7enr * isotope_mass(7,3) / $Mmole;
  my $wfLi6    = $fLiFmole * (1.-$li7enr) * isotope_mass(6,3) / $Mmole;
  my $wfF      = ($fLiFmole+4.*$fUF4mole+2.*$fBeFmole)*$mFmole / $Mmole;		# weight fraction F19
  my $wfBe     = $fBeFmole * $mBemole / $Mmole;
  my $wfU233   = $fUF4mole * $U233fract * isotope_mass(233, 92)  / $Mmole;
  my $wfU234   = $fUF4mole * $U234fract  * isotope_mass(234, 92)  / $Mmole;

  my $ele = 'Li';
  push @matsalt, sprintf "%3d%03d%s  -%10.8f   %%  %s\n", $ELEMENTS{$ele}, 6, $saltmatlib, $wfLi6, $ele;
  push @matsalt, sprintf "%3d%03d%s  -%10.8f   %%  %s\n", $ELEMENTS{$ele}, 7, $saltmatlib, $wfLi7, $ele;
  $ele = 'F';
  push @matsalt, sprintf "%3d%03d%s  -%10.8f   %%  %s\n", $ELEMENTS{$ele}, 19, $saltmatlib, $wfF, $ele;
 $ele = 'Be';
  my $isotabBe = isotope_abundance($ele);
  foreach $iso (sort keys %$isotabBe ) {
    my $massfrac = $isotabBe->{$iso}*0.01 * $wfBe;
    push @matsalt, sprintf "%3d%03d%s  -%10.8f   %%  %s\n", $ELEMENTS{$ele}, $iso, $saltmatlib, $massfrac, $ele;
  }
  $ele = 'U';
  push @matsalt, sprintf "%3d%03d%s  -%10.8f   %%  %s\n", $ELEMENTS{$ele}, 233, $saltmatlib, $wfU233, $ele;
  push @matsalt, sprintf "%3d%03d%s  -%10.8f   %%  %s\n", $ELEMENTS{$ele}, 234, $saltmatlib, $wfU234, $ele;
 }

sub nearest
{ # http://www.perlmonks.org/?node_id=884172
    my ( $dist, $href ) = @_;
    my ( $answer ) = ( sort { abs( $a - $dist ) <=> abs( $b - $dist ) } keys %$href );
    return $href -> { $answer };
}

sub InitElements {
  our @ELEMENTS = qw(
    n
    H                                                                   He
    Li  Be                                          B   C   N   O   F   Ne
    Na  Mg                                          Al  Si  P   S   Cl  Ar
    K   Ca  Sc  Ti  V   Cr  Mn  Fe  Co  Ni  Cu  Zn  Ga  Ge  As  Se  Br  Kr
    Rb  Sr  Y   Zr  Nb  Mo  Tc  Ru  Rh  Pd  Ag  Cd  In  Sn  Sb  Te  I   Xe
    Cs  Ba
        La  Ce  Pr  Nd  Pm  Sm  Eu  Gd  Tb  Dy  Ho  Er  Tm  Yb
            Lu  Hf  Ta  W   Re  Os  Ir  Pt  Au  Hg  Tl  Pb  Bi  Po  At  Rn
    Fr  Ra
        Ac  Th  Pa  U   Np  Pu  Am  Cm  Bk  Cf  Es  Fm  Md  No
            Lr  Rf  Db  Sg  Bh  Hs  Mt  Ds  Uuu Uub Uut Uuq Uup Uuh Uus Uuo );

  our %ELEMENTS;
  for (my $i = 1; $i < @ELEMENTS; ++$i){
    $ELEMENTS{$ELEMENTS[$i]} = $i;
  }
  $ELEMENTS{D} = $ELEMENTS{T} = 1;
}
