<?xml version='1.0'?>
<xsl:stylesheet	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:template name="DateDiff">
        <xsl:param name="yyyymmddA" />
        <xsl:param name="yyyymmddB" />
        <xsl:param name="dateInterval" />
        <xsl:variable name="ESecA">
            <xsl:call-template name="seconds_since_Epoch">
                    <xsl:with-param name="paramyyyymmdd" select="$yyyymmddA"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="ESecB">
            <xsl:call-template name="seconds_since_Epoch">
                <xsl:with-param name="paramyyyymmdd" select="$yyyymmddB"/>
                </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$dateInterval  = 'd'">
                <xsl:value-of select=" ($ESecB - $ESecA) div 86400"/>
            </xsl:when>
            <xsl:when test="$dateInterval  = 'y'">
                <xsl:value-of select=" ($ESecB - $ESecA) div 31536000"/>        
            </xsl:when>
            <xsl:when test="$dateInterval  = 'm'">
                <xsl:value-of select="($ESecB - $ESecA) div 2628000"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
  
    <xsl:template name="DateAdd">
        <xsl:param name="yyyymmddDate" />        
        <xsl:param name="dateInterval" />
        <xsl:param name="numberToAdd" />
        <xsl:variable name="inmonth" select="substring($yyyymmddDate,5,2)" />
        <xsl:variable name="inday" select="substring($yyyymmddDate,7,2)" />
        <xsl:variable name="inyear" select="substring($yyyymmddDate,1,4)" />
        <xsl:choose>

            <xsl:when test="$dateInterval  = 'y'">
                <xsl:variable name="ReturnYear" select="$inyear + $numberToAdd"/>
                <xsl:variable name="PaddedReturnYear">              
                    <xsl:call-template name="FrontPad0">
                        <xsl:with-param name="stringInput" select="$ReturnYear"/><xsl:with-param name="lengthWithPad" select="4"/>
                    </xsl:call-template>          
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="($inmonth = '02') and ($inday = '29')">
                        <xsl:variable name="leap" >
                            <xsl:call-template name="LeapYear"><xsl:with-param name="paramYear" select="$ReturnYear"/></xsl:call-template>                
                        </xsl:variable> 
                        <xsl:choose>
                            <xsl:when test="$leap = 1"><xsl:value-of select="concat($PaddedReturnYear,'0229')"/></xsl:when>
		                <xsl:otherwise><xsl:value-of select="concat($PaddedReturnYear,'0228')"/></xsl:otherwise>
		            </xsl:choose>		          
                    </xsl:when>
                    <xsl:otherwise><xsl:value-of select="concat($PaddedReturnYear,substring($yyyymmddDate,5,4))"/></xsl:otherwise>
                </xsl:choose>
            </xsl:when>
         
            <xsl:when test="$dateInterval  = 'd'">
                <xsl:variable name="ESecs" > 
                    <xsl:call-template name="seconds_since_Epoch">
                        <xsl:with-param name="paramyyyymmdd" select="$yyyymmddDate"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="ReturnDate" > 
                    <xsl:call-template name="EpochtoDate">
                        <xsl:with-param name="EpochSeconds" select="$ESecs + $numberToAdd*86400"/>
                   </xsl:call-template>
                </xsl:variable> 
                <xsl:value-of select="$ReturnDate" />
            </xsl:when>
         
            <xsl:when test="$dateInterval  = 'm'">  
                          
                <xsl:variable name="monthstoadd">
                    <xsl:choose>
                        <xsl:when test="number($numberToAdd) &lt; 0">
                            <xsl:value-of select="( number($numberToAdd)*(-1) mod 12 )*(-1)"></xsl:value-of>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$numberToAdd mod 12"></xsl:value-of>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <xsl:variable name="monthoffset">
                    <xsl:choose>
                        <xsl:when test="number($inmonth) + number($monthstoadd) &gt; 12">
                            <xsl:value-of select="-12" />
                        </xsl:when>
                        <xsl:when test="number($inmonth) + number($monthstoadd) &gt; 0">
                            <xsl:value-of select="0" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="12" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>


                <xsl:variable name="yearstoadd">
                    <xsl:choose>
                        <xsl:when test="number($numberToAdd) &lt; 0">
                            <xsl:value-of select="(floor( (number($numberToAdd)*(-1)) div 12))*(-1)"></xsl:value-of>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="floor( $numberToAdd div 12)"></xsl:value-of>
                        </xsl:otherwise>
                   </xsl:choose>
                </xsl:variable>

                <xsl:variable name="yearreturndate">
                    <xsl:call-template name="DateAdd">
                        <xsl:with-param name="yyyymmddDate" select="string($yyyymmddDate)" />
                        <xsl:with-param name="dateInterval" select="'y'" />
                        <xsl:with-param name="numberToAdd" select="$yearstoadd" />    
                    </xsl:call-template>      
                </xsl:variable>  
                <xsl:variable name="finalyear">
                    <xsl:choose>
                        <xsl:when test="number($monthoffset) = 0">
                            <xsl:value-of select="substring($yearreturndate,1,4)" />
                        </xsl:when>
                        <xsl:when test="number($monthoffset) = 12">
                            <xsl:value-of select="number(substring($yearreturndate,1,4)) - 1" />
                        </xsl:when>
                        <xsl:when test="number($monthoffset) = -12">
                            <xsl:value-of select="number(substring($yearreturndate,1,4)) + 1" />
                        </xsl:when>
                   </xsl:choose>
                </xsl:variable>   
    
                <xsl:variable name="finalmonth">
                    <xsl:call-template name="FrontPad0">
                        <xsl:with-param name="stringInput" select="number($inmonth) + number($monthstoadd) + number($monthoffset)" />
                        <xsl:with-param name="lengthWithPad" select="2" />
                    </xsl:call-template>
                </xsl:variable>

                <xsl:variable name="finalday">
                    <xsl:choose>
                        <xsl:when test="( number($inday) &gt;= 30) and ( (number($finalmonth) = 4) or (number($finalmonth) = 6) or (number($finalmonth) = 9) or (number($finalmonth) = 11) )">
                            <xsl:value-of select="'30'" /> 
                        </xsl:when>
                        <xsl:when test="( number($inday) &gt;= 29) and  (number($finalmonth) = 2)  ">
                            <xsl:variable name="leap" >
                                <xsl:call-template name="LeapYear"><xsl:with-param name="paramYear" select="$finalyear"/></xsl:call-template>                
		            </xsl:variable> 
                          
		            <xsl:choose>
		                <xsl:when test="$leap = 1"><xsl:value-of select="'29'"/></xsl:when>
		                <xsl:otherwise><xsl:value-of select="'28'"/></xsl:otherwise>
		           </xsl:choose>		 
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$inday" />
                        </xsl:otherwise>
                    </xsl:choose>       
                </xsl:variable>
                <xsl:value-of select="concat($finalyear,$finalmonth, $finalday )" />           
             </xsl:when>

             <xsl:otherwise><xsl:value-of select="'invalid input'" /></xsl:otherwise> 
               	     
        </xsl:choose>
    </xsl:template>

    <xsl:template name="FrontPad0">
        <xsl:param name="stringInput" />
        <xsl:param name="lengthWithPad" />
        <xsl:variable name="inputLength" select="string-length($stringInput)"/>	     
        <xsl:choose>
            <xsl:when test="number($inputLength) &lt; number($lengthWithPad)">
                <xsl:call-template name="FrontPad0">
                    <xsl:with-param name="stringInput" select="concat('0',$stringInput)"/>
                    <xsl:with-param name="lengthWithPad" select="$lengthWithPad"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>           
                <xsl:value-of select="$stringInput"/>
            </xsl:otherwise>
        </xsl:choose>	              
    </xsl:template>
	    

<!-- The following templates are derived from: 

http://pubs.opengroup.org/onlinepubs/009695399/basedefs/xbd_chap04.html#tag_04_14
http://www.epochconverter.com/ 
and other sites...             

4.14 Seconds Since the Epoch
A value that approximates the number of seconds that have elapsed since the Epoch. A Coordinated Universal Time name (specified in terms of seconds (tm_sec), minutes (tm_min), hours (tm_hour), days since January 1 of the year (tm_yday), and calendar year minus 1900 (tm_year)) is related to a time represented as seconds since the Epoch, according to the expression below.

If the year is <1970 or the value is negative, the relationship is undefined. If the year is >=1970 and the value is non-negative, the value is related to a Coordinated Universal Time name according to the C-language expression, where tm_sec, tm_min, tm_hour, tm_yday, and tm_year are all integer types:

tm_sec + tm_min*60 + tm_hour*3600 + tm_yday*86400 +
    (tm_year-70)*31536000 + ((tm_year-69)/4)*86400 -
    ((tm_year-1)/100)*86400 + ((tm_year+299)/400)*86400


The relationship between the actual time of day and the current value for seconds since the Epoch is unspecified.

How any changes to the value of seconds since the Epoch are made to align to a desired relationship with the current actual time is implementation-defined. As represented in seconds since the Epoch, each and every day shall be accounted for by exactly 86400 seconds. 

Note: 
The last three terms of the expression add in a day for each year that follows a leap year starting with the first leap year since the Epoch. The first term adds a day every 4 years starting in 1973, the second subtracts a day back out every 100 years starting in 2001, and the third adds a day back in every 400 years starting in 2001. The divisions in the formula are integer divisions; that is, the remainder is discarded leaving only the integer quotient. 
-->  
  

    <xsl:template name="seconds_since_Epoch">
        <xsl:param name="paramyyyymmdd" />
        <xsl:variable name="tm_yday">
            <xsl:call-template name="DaysSinceJan"><xsl:with-param name="yyyymmdd" select="$paramyyyymmdd"></xsl:with-param></xsl:call-template>
        </xsl:variable>
        <xsl:variable name="tm_year" select="number(substring($paramyyyymmdd,1,4)) - 1900" />
        <xsl:value-of select="$tm_yday*86400 + ($tm_year - 70)*31536000 + floor(($tm_year - 69) div 4 )*86400 - floor(($tm_year - 1) div 100)*86400 + floor(($tm_year + 299) div 400)*86400" />
    </xsl:template>  

    <xsl:template name="LeapYear">
        <xsl:param name="paramYear"/> 
            <xsl:choose>
                <xsl:when test="($paramYear mod 400 = 0) or ( ($paramYear mod 100 != 0) and ($paramYear mod 4 = 0) )">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
    </xsl:template>	   
	   	   
    <xsl:template name="DaysSinceJan">
        <xsl:param name="yyyymmdd" />	    	    
        <xsl:variable name="Month"><xsl:value-of select="substring($yyyymmdd,5,2)" /></xsl:variable>
	<xsl:variable name="Day"><xsl:value-of select="substring($yyyymmdd,7,2)" /></xsl:variable>
	<xsl:variable name="Year"><xsl:value-of select="substring($yyyymmdd,1,4)" /></xsl:variable>	    
        <xsl:variable name="Leap"><xsl:call-template name="LeapYear"><xsl:with-param name="paramYear" select="$Year"/></xsl:call-template></xsl:variable>
        <xsl:choose>
            <xsl:when test="$Leap = 1" >
                <xsl:choose>
				<xsl:when test="$Month=01"><xsl:value-of select="0 + number($Day) - 1" /></xsl:when>
				<xsl:when test="$Month=02"><xsl:value-of select="31 + number($Day) - 1" /></xsl:when>
				<xsl:when test="$Month=03"><xsl:value-of select="60 + number($Day) - 1" /></xsl:when>
				<xsl:when test="$Month=04"><xsl:value-of select="91 + number($Day) - 1" /></xsl:when>
				<xsl:when test="$Month=05"><xsl:value-of select="121 + number($Day) - 1" /></xsl:when>
				<xsl:when test="$Month=06"><xsl:value-of select="152 + number($Day) - 1" /></xsl:when>
				<xsl:when test="$Month=07"><xsl:value-of select="182 + number($Day) - 1" /></xsl:when>
				<xsl:when test="$Month=08"><xsl:value-of select="213 + number($Day) - 1" /></xsl:when>
				<xsl:when test="$Month=09"><xsl:value-of select="244 + number($Day) - 1" /></xsl:when>
				<xsl:when test="$Month=10"><xsl:value-of select="274 + number($Day) - 1" /></xsl:when>
				<xsl:when test="$Month=11"><xsl:value-of select="305 + number($Day) - 1" /></xsl:when>
				<xsl:when test="$Month=12"><xsl:value-of select="335 + number($Day) - 1" /></xsl:when>
                </xsl:choose>
            </xsl:when>
	    <xsl:otherwise>
	      	<xsl:choose>
				<xsl:when test="$Month=01"><xsl:value-of select="0 + number($Day) - 1" /></xsl:when>
				<xsl:when test="$Month=02"><xsl:value-of select="31 + number($Day) - 1" /></xsl:when>
				<xsl:when test="$Month=03"><xsl:value-of select="59 + number($Day) - 1" /></xsl:when>
				<xsl:when test="$Month=04"><xsl:value-of select="90 + number($Day) - 1" /></xsl:when>
				<xsl:when test="$Month=05"><xsl:value-of select="120 + number($Day) - 1" /></xsl:when>
				<xsl:when test="$Month=06"><xsl:value-of select="151 + number($Day) - 1" /></xsl:when>
				<xsl:when test="$Month=07"><xsl:value-of select="181 + number($Day) - 1" /></xsl:when>
				<xsl:when test="$Month=08"><xsl:value-of select="212 + number($Day) - 1" /></xsl:when>
				<xsl:when test="$Month=09"><xsl:value-of select="243 + number($Day) - 1" /></xsl:when>
				<xsl:when test="$Month=10"><xsl:value-of select="273 + number($Day) - 1" /></xsl:when>
				<xsl:when test="$Month=11"><xsl:value-of select="304 + number($Day) - 1" /></xsl:when>
				<xsl:when test="$Month=12"><xsl:value-of select="334 + number($Day) - 1" /></xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>    
	   
    <xsl:template name="EpochtoDate">
        <xsl:param name="EpochSeconds" />


        <xsl:variable name="zyears" select="floor($EpochSeconds div 31536000)" />         
        <xsl:variable name="zDYears" select="1970 + $zyears" />
        <xsl:variable name="zLeap"><xsl:call-template name="LeapYear"><xsl:with-param name="paramYear" select="$zDYears"/></xsl:call-template></xsl:variable>
        <xsl:variable name="zLeapDays" select="floor(($zyears + 70 - 69) div 4 ) - floor(($zyears + 70  - 1) div 100) + floor(($zyears + 70  + 299) div 400) - 1" />
        <xsl:variable name="zdays" select="(($EpochSeconds - $zyears*365*86400) div 86400)  - $zLeapDays" />


        <xsl:variable name="years">
             <xsl:choose>
                 <xsl:when test="$zdays &lt;= 0">
                    <xsl:value-of select="floor($EpochSeconds div 31536000)-1" />
                 </xsl:when>
                 <xsl:otherwise>
                    <xsl:value-of select="floor($EpochSeconds div 31536000)" />
                 </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>


        <xsl:variable name="DYears" select="1970 + $years" />
        <xsl:variable name="Leap"><xsl:call-template name="LeapYear"><xsl:with-param name="paramYear" select="$DYears"/></xsl:call-template></xsl:variable>
        <xsl:variable name="LeapDays" select="floor(($years + 70 - 69) div 4 ) - floor(($years + 70  - 1) div 100) + floor(($years + 70  + 299) div 400) - 1" />
        <xsl:variable name="days" select="(($EpochSeconds - $years*365*86400) div 86400)  - $LeapDays" />

	    
        <xsl:value-of select="$DYears" />

      <xsl:variable name="finalmonthday">
        <xsl:choose>
            <xsl:when test="$Leap = 1" >
                <xsl:choose>
				             <xsl:when test=" $days &lt;= 31"><xsl:value-of select="concat('01',($days))" /></xsl:when>
				             <xsl:when test="($days &gt; 31) and ($days &lt;= 60)">
                          <xsl:value-of select="'02'" />
                          <xsl:call-template name="FrontPad0">
                                  <xsl:with-param name="stringInput" select="($days - 31)" />
                                  <xsl:with-param name="lengthWithPad" select="2" />
                          </xsl:call-template>
                    </xsl:when>
                  <xsl:when test="($days &gt; 60) and ($days &lt;= 91)"><xsl:value-of select="concat('03',($days - 60))" /></xsl:when>
                  <xsl:when test="($days &gt; 91) and ($days &lt;= 121)"><xsl:value-of select="concat('04',($days - 91))" /></xsl:when>
                  <xsl:when test="($days &gt; 121) and ($days &lt;= 152)"><xsl:value-of select="concat('05',($days - 121))" /></xsl:when>
                  <xsl:when test="($days &gt; 152) and ($days &lt;= 182)"><xsl:value-of select="concat('06',($days - 152))" /></xsl:when>
                  <xsl:when test="($days &gt; 182) and ($days &lt;= 213)"><xsl:value-of select="concat('07',($days - 182))" /></xsl:when>
                  <xsl:when test="($days &gt; 213) and ($days &lt;= 244)"><xsl:value-of select="concat('08',($days - 213))" /></xsl:when>
                  <xsl:when test="($days &gt; 244) and ($days &lt;= 274)"><xsl:value-of select="concat('09',($days - 244))" /></xsl:when>
                  <xsl:when test="($days &gt; 274) and ($days &lt;= 305)"><xsl:value-of select="concat('10',($days - 274))" /></xsl:when>
                  <xsl:when test="($days &gt; 305) and ($days &lt;= 335)"><xsl:value-of select="concat('11',($days - 305))" /></xsl:when>
                  <xsl:when test="($days &gt; 335) "><xsl:value-of select="concat('12',($days - 335))" /></xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
	      	      <xsl:choose>
				<xsl:when test=" $days &lt;= 31"><xsl:value-of select="concat('01',($days))" /></xsl:when>
				<xsl:when test="($days &gt; 31) and ($days &lt;= 59)"><xsl:value-of select="concat('02',($days - 31))" /></xsl:when>
				<xsl:when test="($days &gt; 59) and ($days &lt;= 90)"><xsl:value-of select="concat('03',($days - 59))" /></xsl:when>
				<xsl:when test="($days &gt; 90) and ($days &lt;= 120)"><xsl:value-of select="concat('04',($days - 90))" /></xsl:when>
				<xsl:when test="($days &gt; 120) and ($days &lt;= 151)"><xsl:value-of select="concat('05',($days - 120))" /></xsl:when>
				<xsl:when test="($days &gt; 151) and ($days &lt;= 181)"><xsl:value-of select="concat('06',($days - 151))" /></xsl:when>
				<xsl:when test="($days &gt; 181) and ($days &lt;= 212)"><xsl:value-of select="concat('07',($days - 181))" /></xsl:when>
				<xsl:when test="($days &gt; 212) and ($days &lt;= 243)"><xsl:value-of select="concat('08',($days - 212))" /></xsl:when>
				<xsl:when test="($days &gt; 243) and ($days &lt;= 273)"><xsl:value-of select="concat('09',($days - 243))" /></xsl:when>
				<xsl:when test="($days &gt; 273) and ($days &lt;= 304)"><xsl:value-of select="concat('10',($days - 273))" /></xsl:when>
				<xsl:when test="($days &gt; 304) and ($days &lt;= 334)"><xsl:value-of select="concat('11',($days - 304))" /></xsl:when>
				<xsl:when test="($days &gt; 334) "><xsl:value-of select="concat('12',($days - 334))" /></xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        
      </xsl:variable>

      <xsl:variable name="paddedfinalday">
        <xsl:call-template name="FrontPad0">
          <xsl:with-param name="stringInput" select="substring($finalmonthday,3,2)" />
          <xsl:with-param name="lengthWithPad" select="2" />
        </xsl:call-template>
      </xsl:variable>

      <xsl:value-of select ="substring($finalmonthday,1,2)"/>
      <xsl:value-of select ="$paddedfinalday"/>
      
    </xsl:template>

</xsl:stylesheet>