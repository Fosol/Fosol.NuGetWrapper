<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns=""
                xmlns:nuspec="http://schemas.microsoft.com/packaging/2013/05/nuspec.xsd"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                exclude-result-prefixes="msxsl nuspec"
>
  <xsl:output method="xml" indent="yes"/>

  <xsl:param name="id"/>
  <xsl:param name="version"/>
  <xsl:param name="title"/>
  <xsl:param name="authors"/>
  <xsl:param name="owners" select="$authors"/>
  <xsl:param name="description"/>
  <xsl:param name="releaseNotes"/>
  <xsl:param name="summary"/>
  <xsl:param name="language"/>
  <xsl:param name="projectUrl"/>
  <xsl:param name="iconUrl"/>
  <xsl:param name="licenseUrl"/>
  <xsl:param name="copyright"/>
  <xsl:param name="requireLicenseAcceptance"/>
  <xsl:param name="tags"/>
  
  <!-- files to be included. -->
  <xsl:param name="build"/>
  <xsl:param name="content"/>
  <xsl:param name="lib"/>
  <xsl:param name="tools"/>

  <xsl:variable name="enLow" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="enUp" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

  <xsl:variable name="newline">
    <xsl:value-of select="'&#xa;'" disable-output-escaping="no"/>
  </xsl:variable>
  <xsl:variable name="tab">
    <xsl:value-of select="'&#x9;'" disable-output-escaping="no"/>
  </xsl:variable>

  <xsl:template match="/">
    <xsl:element name="package" namespace="http://schemas.microsoft.com/packaging/2013/05/nuspec.xsd">

      <!-- Add metadata information. -->
      <xsl:apply-templates select="nuspec:package/nuspec:metadata"/>

      <!-- Add files to be included in the package -->
      <xsl:choose>
        <xsl:when test="not(nuspec:package/nuspec:files)">
          <xsl:call-template name="files"></xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="nuspec:package/nuspec:files"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

  <xsl:template match="nuspec:metadata">
    <xsl:copy>
      <xsl:apply-templates select="nuspec:id"/>
      <xsl:apply-templates select="nuspec:version"/>
      <xsl:apply-templates select="nuspec:title"/>
      <xsl:apply-templates select="nuspec:authors"/>
      <xsl:apply-templates select="nuspec:owners"/>
      <xsl:apply-templates select="nuspec:description"/>
      <xsl:apply-templates select="nuspec:releaseNotes"/>
      <xsl:apply-templates select="nuspec:summary"/>
      <xsl:apply-templates select="nuspec:language"/>
      <xsl:apply-templates select="nuspec:projectUrl"/>
      <xsl:apply-templates select="nuspec:iconUrl"/>
      <xsl:apply-templates select="nuspec:licenseUrl"/>
      <xsl:apply-templates select="nuspec:copyright"/>
      <xsl:apply-templates select="nuspec:requireAcceptanceLicense"/>
      <xsl:apply-templates select="nuspec:dependencies"/>
      <xsl:apply-templates select="nuspec:references"/>
      <xsl:apply-templates select="nuspec:frameworkAssemblies"/>
      <xsl:apply-templates select="nuspec:tags"/>
      <xsl:apply-templates select="nuspec:developmentDependency"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="nuspec:id">
    <xsl:copy>
      <xsl:choose>
        <xsl:when test="text()='$id$' and $id!=''">
          <xsl:value-of select="$id"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="text()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="nuspec:version">
    <xsl:copy>
      <xsl:choose>
        <xsl:when test="text()='$version$' and $version!=''">
          <xsl:value-of select="$version"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="text()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="nuspec:title">
    <xsl:copy>
      <xsl:choose>
        <xsl:when test="text()='$title$' and $title!=''">
          <xsl:value-of select="$title"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="text()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="nuspec:authors">
    <xsl:copy>
      <xsl:choose>
        <xsl:when test="text()='$authors$' and $authors!=''">
          <xsl:value-of select="$authors"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="text()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="nuspec:owners">
    <xsl:copy>
      <xsl:choose>
        <xsl:when test="text()='$owners$' and $owners!=''">
          <xsl:value-of select="$owners"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="text()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="nuspec:description">
    <xsl:copy>
      <xsl:choose>
        <xsl:when test="text()='$description$' and $description!=''">
          <xsl:value-of select="$description"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="text()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="nuspec:releaseNotes">
    <xsl:copy>
      <xsl:choose>
        <xsl:when test="text()='$releaseNotes$' and $releaseNotes!=''">
          <xsl:value-of select="$releaseNotes"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="text()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="nuspec:summary">
    <xsl:copy>
      <xsl:choose>
        <xsl:when test="text()='$summary$' and $summary!=''">
          <xsl:value-of select="$summary"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="text()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="nuspec:language">
    <xsl:copy>
      <xsl:choose>
        <xsl:when test="text()='$language$' and $language!=''">
          <xsl:value-of select="$language"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="text()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="nuspec:projectUrl">
    <xsl:copy>
      <xsl:choose>
        <xsl:when test="text()='$projectUrl$' and $projectUrl!=''">
          <xsl:value-of select="$projectUrl"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="text()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="nuspec:iconUrl">
    <xsl:copy>
      <xsl:choose>
        <xsl:when test="text()='$iconUrl$' and $iconUrl!=''">
          <xsl:value-of select="$iconUrl"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="text()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="nuspec:licenseUrl">
    <xsl:copy>
      <xsl:choose>
        <xsl:when test="text()='$licenseUrl$' and $licenseUrl!=''">
          <xsl:value-of select="$licenseUrl"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="text()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="nuspec:copyright">
    <xsl:copy>
      <xsl:choose>
        <xsl:when test="text()='$copyright$' and $copyright!=''">
          <xsl:value-of select="$copyright"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="text()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="nuspec:requireLicenseAcceptance">
    <xsl:copy>
      <xsl:choose>
        <xsl:when test="text()='$requireLicenseAcceptance$' and $requireLicenseAcceptance!=''">
          <xsl:value-of select="$requireLicenseAcceptance"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="text()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="nuspec:dependencies">
    <xsl:copy>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="nuspec:references">
    <xsl:copy>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="nuspec:frameworkAssemblies">
    <xsl:copy>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="nuspec:tags">
    <xsl:copy>
      <xsl:choose>
        <xsl:when test="text()='$tags$' and $tags!=''">
          <xsl:value-of select="$tags"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="text()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="nuspec:developmentDependency">
    <xsl:copy>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="nuspec:files">
    <xsl:copy>
      <xsl:value-of select="$newline"/>
      <!-- Dynamically add the files in the Build directory -->
      <xsl:if test="$build!=''">
        <xsl:call-template name="file">
          <xsl:with-param name="value" select="$build"/>
          <xsl:with-param name="files" select="*"/>
        </xsl:call-template>
      </xsl:if>
      <!-- Dynamically add the files in the Content directory -->
      <xsl:if test="$content!=''">
        <xsl:call-template name="file">
          <xsl:with-param name="value" select="$content"/>
          <xsl:with-param name="files" select="*"/>
        </xsl:call-template>
      </xsl:if>
      <!-- Dynamically add the files in the Lib directory -->
      <xsl:if test="$lib!=''">
        <xsl:call-template name="file">
          <xsl:with-param name="value" select="$lib"/>
          <xsl:with-param name="files" select="*"/>
        </xsl:call-template>
      </xsl:if>
      <!-- Dynamically add the files in the Tools directory -->
      <xsl:if test="$tools!=''">
        <xsl:call-template name="file">
          <xsl:with-param name="value" select="$tools"/>
          <xsl:with-param name="files" select="*"/>
        </xsl:call-template>
      </xsl:if>
      <!-- Add all the files that are in the project nuspec -->
      <xsl:for-each select="*">
        <xsl:value-of select="concat($tab, $tab)"/>
        <xsl:copy-of select="."/>
        <xsl:value-of select="$newline"/>
      </xsl:for-each>
      <xsl:value-of select="$tab"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="files">
    <xsl:element name="files" namespace="http://schemas.microsoft.com/packaging/2013/05/nuspec.xsd">
      <xsl:value-of select="$newline"/>
      <!-- Dynamically add the files in the Build directory -->
      <xsl:if test="$build!=''">
        <xsl:call-template name="file">
          <xsl:with-param name="value" select="$build"/>
        </xsl:call-template>
      </xsl:if>
      <!-- Dynamically add the files in the Content directory -->
      <xsl:if test="$content!=''">
        <xsl:call-template name="file">
          <xsl:with-param name="value" select="$content"/>
        </xsl:call-template>
      </xsl:if>
      <!-- Dynamically add the files in the Lib directory -->
      <xsl:if test="$lib!=''">
        <xsl:call-template name="file">
          <xsl:with-param name="value" select="$lib"/>
        </xsl:call-template>
      </xsl:if>
      <!-- Dynamically add the files in the Tools directory -->
      <xsl:if test="$tools!=''">
        <xsl:call-template name="file">
          <xsl:with-param name="value" select="$tools"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:value-of select="$tab"/>
    </xsl:element>
  </xsl:template>

  <!-- Separate a string and convert it into XML nodes -->
  <xsl:template name="file">
    <xsl:param name="value" select="."/>
    <xsl:param name="separator" select="';'"/>
    <xsl:param name="files" select="."/>

    <xsl:if test="string-length($value) > 0">
      <xsl:variable name="nextItem" select="substring-before(concat($value, $separator), $separator)"/>
      <xsl:variable name="exists" select="$files[translate(@src, $enUp, $enLow) = translate($nextItem, $enUp, $enLow)]/@src"/>
      
      <!-- Only add the file if it doesn't already exist. -->
      <xsl:if test="not($exists)">
        <xsl:value-of select="concat($tab, $tab)"/>
        <xsl:element name="file" namespace="http://schemas.microsoft.com/packaging/2013/05/nuspec.xsd">
          <xsl:attribute name="src">
            <xsl:value-of select="$nextItem"/>
          </xsl:attribute>
          <xsl:attribute name="target">
            <xsl:value-of select="$nextItem"/>
          </xsl:attribute>
        </xsl:element>
        <xsl:value-of select="$newline"/>
      </xsl:if>
      
      <xsl:call-template name="file">
        <xsl:with-param name="value" select="substring-after($value, $separator)"/>
        <xsl:with-param name="separator" select="$separator"/>
        <xsl:with-param name="files" select="$files"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
