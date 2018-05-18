=pod
This file splits or concatenates files.
The file can be either pgn or aif.
The type of file is realized from the extension.
Flag '--split' represents split and '--concat' represent concatenation.
After split all the file name are appeneded with _eXXXX 
where XXXX ranges from 0000 to 9999. 
For example:
Test.aif can be splited and  Test_e0000.aif to Test_e0088.aif files may be generated
if the aif file had 89 games.
If pack is set, then each file will contain that many games set in pack

usage:
perl SplitOrConcat.pl --file A\*.aif --split --pack 10 
perl SplitOrConcat.pl --file All.aif --concat (Looks for filenames All_e*.aif and concatenates them).
perl SplitOrConcat.pl --file A\*.pgn --split  

=cut
use warnings;
use strict;
use Getopt::Long;
my $fileExtPattern = '[0-9]'x4;
my $inputFileGlob;
my $performSplit;
my $performConcat;
my $packSize = 1;

GetOptions(
   "file=s"  => \$inputFileGlob,
   "split"   => \$performSplit,
   "concat"  => \$performConcat,
   "pack:i"  => \$packSize,
);


if((!$inputFileGlob) || !($performSplit xor $performConcat))
{
   print "Usage:\n
   perl SplitOrConcat.pl --file A\*.aif --split --pack 10\n
   perl SplitOrConcat.pl --file All.aif --concat (Looks for filenames All_e*.aif and concatenates them)\n
   perl SplitOrConcat.pl --file A\*.pgn --split\n";
   die;
}

my $isPGN = 0;
my $isAIF = 0;
if($inputFileGlob =~m/\.aif$/)
{
   $isAIF = 1;
}
elsif($inputFileGlob =~m/\.pgn$/)
{
   $isPGN = 1;
}

if (!($isAIF || $isPGN))
{
   print STDERR "Input File should have extension either pgn or aif\n";
   die;
}

if($performSplit)
{
   my @files = glob "$inputFileGlob";
   my $indexToRemove = 0;
   while($indexToRemove <= $#files)
   {
      my $fileName = $files[$indexToRemove];
      warn "Filename $fileName\n";
      if($fileName =~ m/e\d{4}\.(aif|pgn)/)
      {
         # Not splitin already splited files
         splice (@files, $indexToRemove, 1);
      }
      else
      {
         $indexToRemove++;
      }
   }

   foreach my $fileName (@files)
   {
      print "$fileName\n";
      &splitIntoFile($fileName, $isPGN, $packSize);
   }
}
if($performConcat)
{
   # TODO: Make a array of array 
   # Where the internal array matches all the games where 
   # except the extension everything is the same. 
   #
   my $appendedFileName = $inputFileGlob;
   if($appendedFileName =~ m/(.*)\.(aif|pgn)/)
   {
      my $FileNameWildCard = $1;
      $appendedFileName =~s/$FileNameWildCard/$FileNameWildCard\_e$fileExtPattern\*/;
      print "Appended Filename = $appendedFileName\n";       
   }

   my @files = glob "$appendedFileName";
   foreach my $fileName (@files)
   {
      warn "Filename $fileName\n";
   }
   &concatFile(\@files); 

}
##########################################
# Concates files and then remove split files.
sub concatFile 
{
   my $inputFileListRef = shift;
   my @outFileList = ();
   foreach my $splitFile (@$inputFileListRef)
   {
      # Get the original file name 
      my $outFileName = "";
      if ($splitFile =~ m/(.*)_e\d{4}(.*\.)(pgn|aif)/)
      {
         $outFileName = $1.$2.$3;
         print STDERR "Adding File $splitFile to $outFileName\n";
         if (grep {$outFileName eq $_} @outFileList)
         {
            system qq( cat "$splitFile" >> "$outFileName" );
         }
         else
         {
            system qq( cat "$splitFile" > "$outFileName" );
            push(@outFileList, $outFileName);
         }
         system qq( rm "$splitFile"); 
      }
   }
}
############################################
# Split file
sub splitIntoFile{
   my ($fileName, $isPGN, $packSize) = @_;

   my $tagToSplit = ($isPGN ? '^\[Event ' : '^\[GameID ');
   my @gameLines = ();
   open(my $INPUT_FH,$fileName) or die "Could not open $fileName: $!";

   my $gameFound = 0;
   my $gameCounter = 0;
   my $fileCounter = 0;
   while(my $line = <$INPUT_FH>)
   {
      if ($line =~ m/$tagToSplit/) {
         my $currentGameSize = @gameLines;
         if (($currentGameSize != 0) && 
            (($gameCounter)%$packSize == 0))
         {
            # Write to a new file
            &writeToFile($fileName, $fileCounter * $packSize,\@gameLines); 
            @gameLines = ();
            $fileCounter++;
         }
         $gameFound = 1;
         $gameCounter++;
         push(@gameLines,$line);
      }
      else
      {
         if ($gameFound == 1)
         {
            push(@gameLines,$line);
         }
      }
   }
   # Storing the last game
   if (($gameFound == 1) && (scalar @gameLines != 0))
   {
      # Write to a new file
      &writeToFile($fileName,$fileCounter*$packSize,\@gameLines); 
      @gameLines = ();
      $gameCounter++;
   }
}
####
#Gets called from writeToFile
#Writes the content from an array to a file specified
sub writeArrayToFile{
   my ($fileName,$arrayRef) = @_;
   open (my $OUT_FILE, '>', $fileName) or 
   die "Could not open $fileName: $!";

   foreach (@$arrayRef)
   {
      print $OUT_FILE "$_";
   }
}

# Generae Output file name from input file and then 
# writes the splited output file
sub writeToFile{
   my ($inputFileName,$fileCounter,$gameLineRef) = @_;
   my ($fileStartsWith,$fileExt) = ($inputFileName =~ m/(.*)\.(pgn|aif)/);
   my $ext = "_e".sprintf("%04d",$fileCounter).'.'.$fileExt;
   my $outputFile = $fileStartsWith.$ext;
   &writeArrayToFile($outputFile,$gameLineRef); 
}

# Splits PGN and generates MANY small PGNs
sub splitPGN{
   my $fileName = shift;
   my @gameLines = ();
   open(my $PGN_FH,$fileName) or die "Could not open $fileName: $!";

   my $gameFound = 0;
   my $fileCounter = 0;
   while(my $line = <$PGN_FH>)
   {
      if ($line =~ m/^\[Event /) {
         my $currentGameSize = @gameLines;
         if ($currentGameSize != 0)
         {
            # Write to a new file
            &writeToFile($fileName,$fileCounter,\@gameLines); 
            @gameLines = ();
            $fileCounter++;
         }
         $gameFound = 1;
         push(@gameLines,$line);
      }
      else
      {
         if ($gameFound == 1)
         {
            push(@gameLines,$line);
         }
      }
   }
   # Storing the last game
   if ($gameFound == 1)
   {
      # Write to a new file
      &writeToFile($fileName,$fileCounter,\@gameLines); 
      @gameLines = ();
      $fileCounter++;
   }
}


