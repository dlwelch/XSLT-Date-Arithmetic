<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="date_arithmetic.xsl"/>

<xsl:template match="/">
<html>
<body>
  <table>      
    <xsl:for-each select="top/dateadd">
    <tr>
      <td><xsl:value-of select="startdate"/></td>
      <td align="center">+</td>
      <td align="right"><xsl:value-of select="numtoadd"/></td>
      <td><xsl:value-of select="dateinterval"/></td>
      <td align="center">=</td>
      <td>
      
<xsl:variable name="mdy">
<xsl:choose>
<xsl:when test="dateinterval = 'days'"><xsl:value-of select="'d'" /></xsl:when>
<xsl:when test="dateinterval = 'months'"><xsl:value-of select="'m'" /></xsl:when>
<xsl:when test="dateinterval = 'years'"><xsl:value-of select="'y'" /></xsl:when>
</xsl:choose>
</xsl:variable>  
    
<xsl:variable name="returndate">
<xsl:call-template name="DateAdd">
   <xsl:with-param name="yyyymmddDate" select="translate(startdate,'-','')" />
   <xsl:with-param name="dateInterval" select="$mdy" />
   <xsl:with-param name="numberToAdd" select="numtoadd" />    
</xsl:call-template>      
</xsl:variable>  

<xsl:value-of select="concat(substring($returndate,5,2),'/',substring($returndate,7,2),'/',substring($returndate,1,4))"/>
      </td>
    </tr>
    </xsl:for-each>    
</table>

  <table cellspacing="0" cellpadding="0">
    <xsl:for-each select="top/datediff">          
      <xsl:variable name="mdy">
            <xsl:choose>
              <xsl:when test="dateinterval = 'days'">
                <xsl:value-of select="'d'" />
              </xsl:when>
              <xsl:when test="dateinterval = 'months'">
                <xsl:value-of select="'m'" />
              </xsl:when>
              <xsl:when test="dateinterval = 'years'">
                <xsl:value-of select="'y'" />
              </xsl:when>
            </xsl:choose>
          </xsl:variable>

          <xsl:variable name="returndays">
            <xsl:call-template name="DateDiff">
              <xsl:with-param name="yyyymmddA" select="translate(datea,'-','')" />
              <xsl:with-param name="yyyymmddB" select="translate(dateb,'-','')" />
              <xsl:with-param name="dateInterval" select="$mdy" />
            </xsl:call-template>
          </xsl:variable>
       <tr>
        <td>Difference between <xsl:value-of select="datea"/> and 
        <xsl:value-of select="dateb"/> is <br /> 
        <xsl:value-of select="concat( $returndays, ' ', dateinterval)"/>
        </td>
      </tr>
    </xsl:for-each>
  </table>  

<table  style="font-size:10pt;">
<xsl:for-each select="top/converttoseconds">
    <tr>
      <td><xsl:value-of select="seconds"/> seconds since Jan 1, 1970 is </td>
      <td>
      <xsl:variable name="secdate">
       <xsl:call-template name="EpochtoDate"><xsl:with-param name="EpochSeconds" select="seconds" /></xsl:call-template>
      </xsl:variable>
      <xsl:value-of select="concat(substring($secdate,1,4),'-',substring($secdate,5,2),'-',substring($secdate,7,2))"/> 
      </td>
    </tr>
    </xsl:for-each>
</table>


<table  style="font-size:10pt;">
<xsl:for-each select="top/converttodate">
    <tr>
      <td><xsl:value-of select="date"/> is </td>
      <td>
      <xsl:call-template name="seconds_since_Epoch"><xsl:with-param name="paramyyyymmdd" select="translate(date,'-','')" /></xsl:call-template>
      </td>
      <td> seconds since Jan 1, 1970</td>
    </tr>
    </xsl:for-each>
</table>
</body>
</html>

</xsl:template>

</xsl:stylesheet> 