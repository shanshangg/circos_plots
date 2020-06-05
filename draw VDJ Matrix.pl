#!/usr/bin/perl -w

use strict;
use warnings;
use Math::Trig;

my $pathname = shift;      # 从外部读入数据
$pathname =~ s[\\][/]g;    # 将\斜杠替换为/斜杠

my $Data1FilePath = $pathname."InputData_L_gene.csv";   # 设置输入文件
open(DATA1, '<', $Data1FilePath) or die "Could not open '$Data1FilePath' $!\n";
my $lineNumberInDataFile1 = 0;

my $mode = "L-VJ";    # H-VJ,L-VJ, VD, JD
my @var1;          # GERMLINE_V_CALL
my @var2;          # GERMLINE_D_CALL
my @var3;          # GERMLINE_J_CALL

my @outputVar1;    # 统计后的结果数组
my @outputVar2;    # 统计后的结果数组
my @outputNumber;  # 统计后的结果数组

my $Flag = 1; 
my $countNum;      # 矩阵中的每个数值
my $lineNumberOutput = 1;

while ( defined( my $line1 = <DATA1> ) )  # 逐行输入文件中数据
{
   chomp $line1;
   my @fields1 = split ",", $line1;
   $var1[$lineNumberInDataFile1] = $fields1[0];
   $var2[$lineNumberInDataFile1] = $fields1[1];
   $var3[$lineNumberInDataFile1] = $fields1[2];
   
   if($var1[$lineNumberInDataFile1] eq "") {$var1[$lineNumberInDataFile1] = ".";}
   if($var2[$lineNumberInDataFile1] eq "") {$var2[$lineNumberInDataFile1] = ".";}
   if($var3[$lineNumberInDataFile1] eq "") {$var3[$lineNumberInDataFile1] = ".";}

   $lineNumberInDataFile1++;
}
print "\n 总数据行数 : ".$lineNumberInDataFile1."\n";

if($mode eq "H-VJ" || $mode eq "L-VJ")
{
	$outputVar1[0] = $var1[0];
	$outputVar2[0] = $var2[0];
	$outputNumber[0] = 1;
	
	 for ( my $i = 0; $i < $lineNumberInDataFile1; $i++ )
	{   
		$Flag = 1;
		for( my $j = 0; $j < $lineNumberOutput; $j++ )
	   {
		  if($outputVar1[$j] eq $var1[$i] && $outputVar2[$j] eq $var2[$i]) 
		 { 
		   $outputNumber[$j]++; 
		   $Flag = 0;  # 记录中已存在
		 }  # end if
	   }    # end for
	   
	   # FLag = 1,则记录中不存在
	   if($Flag)
	  {
		$outputVar1[$lineNumberOutput] = $var1[$i];
		$outputVar2[$lineNumberOutput] = $var2[$i];
		$outputNumber[$lineNumberOutput] = 1;
		$lineNumberOutput++;
	  }
	}   # end for
}

if($mode eq "VD")  
{
	$outputVar1[0] = $var1[0];
	$outputVar2[0] = $var3[0];
	$outputNumber[0] = 1;
	
	 for ( my $i = 0; $i < $lineNumberInDataFile1; $i++ )
	{   
		$Flag = 1;
		for( my $j = 0; $j < $lineNumberOutput; $j++ )
	   {
		  if($outputVar1[$j] eq $var1[$i] && $outputVar2[$j] eq $var3[$i]) 
		 { 
		   $outputNumber[$j]++; 
		   $Flag = 0;  # 记录中已存在
		 }  # end if
	   }    # end for
	   
	   # FLag = 1,则记录中不存在
	   if($Flag)
	  {
		$outputVar1[$lineNumberOutput] = $var1[$i];
		$outputVar2[$lineNumberOutput] = $var3[$i];
		$outputNumber[$lineNumberOutput] = 1;
		$lineNumberOutput++;
	  }
	}   # end for
}

if($mode eq "JD")  # JD
{
	$outputVar1[0] = $var2[0];
	$outputVar2[0] = $var3[0];
	$outputNumber[0] = 1;
	
	 for ( my $i = 0; $i < $lineNumberInDataFile1; $i++ )
	{   
		$Flag = 1;
		for( my $j = 0; $j < $lineNumberOutput; $j++ )
	   {
		  if($outputVar1[$j] eq $var2[$i] && $outputVar2[$j] eq $var3[$i]) 
		 { 
		   $outputNumber[$j]++; 
		   $Flag = 0;  # 记录中已存在
		 }  # end if
	   }    # end for
	   
	   # FLag = 1,则记录中不存在
	   if($Flag)
	  {
		$outputVar1[$lineNumberOutput] = $var2[$i];
		$outputVar2[$lineNumberOutput] = $var3[$i];
		$outputNumber[$lineNumberOutput] = 1;
		$lineNumberOutput++;
	  }
	}   # end for
}


print "\n 处理后数据行数 : ".$lineNumberOutput."\n";

my $reportFile = ">".$pathname.$mode."-ResultData.csv";      # 创建并打开结果报告文件
open (Report,$reportFile);                                 

for ( my $j = 0; $j < $lineNumberOutput; $j++ )        # 将结果写入报告文件中
{
	printf Report ("%s,%s,%d\n",   #  占位符：%s表示字符串，%d整数，%6.3f浮点数
					$outputVar1[$j],
					$outputVar2[$j],
					$outputNumber[$j]);

#printf Report ("%6.3f\n",$outputResult[$j]);    

}
close Report;                                              # 关闭报告文件
print "\n\n计算结束，请查看ResultData.csv文件中的结果.\n\n";

my $reportMatrix = ">".$pathname.$mode."-ResultMarix.txt"; 
open (Matrix,$reportMatrix); 
printf Matrix ("labels");
for ( my $j = 0; $j < $lineNumberOutput; $j++ )        # 将结果写入报告文件中
{
	printf Matrix ("\t%s",$outputVar2[$j]);

}
printf Matrix ("\n");

for ( my $i = 0; $i < $lineNumberOutput; $i++ )
{
	printf Matrix ("%s",$outputVar1[$i]);
	for ( my $j = 0; $j < $lineNumberOutput; $j++ )
   {
      $countNum = 0;
	  for ( my $k = 0; $k < $lineNumberOutput; $k++ )
	 {
	    if($outputVar1[$k] eq $outputVar1[$i] && $outputVar2[$k] eq $outputVar2[$j]) 
	   {
		   $countNum = $outputNumber[$k];
	   } # end if
	 }  # end for
	  printf Matrix ("\t%d",$countNum);

   }  
	printf Matrix ("\n");
}

close Matrix;                                              # 关闭报告文件
print "\n\n矩阵输出完成.\n\n";













