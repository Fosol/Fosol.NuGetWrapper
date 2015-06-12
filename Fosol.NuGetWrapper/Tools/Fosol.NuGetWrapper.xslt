<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns="http://schemas.microsoft.com/packaging/2013/05/nuspec.xsd"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                exclude-result-prefixes="msxsl"
>
  <xsl:output method="xml" indent="yes"/>

  <xsl:param name="id"/>
  <xsl:param name="version"/>
  <xsl:param name="title"/>
  <xsl:param name="authors"/>
  <xsl:param name="owners" select="$authors"/>
  <xsl:param name="description"/>
  <xsl:param name="build"/>
  <xsl:param name="content"/>
  <xsl:param name="lib"/>
  <xsl:param name="tools"/>

  <xsl:variable name="newline">
    <xsl:value-of select="'&#xa;'" disable-output-escaping="no"/>
  </xsl:variable>
  <xsl:variable name="tab">
    <xsl:value-of select="'&#x9;'" disable-output-escaping="no"/>
  </xsl:variable>

  <xsl:template match="node()|@*">
    <xsl:choose>
      <xsl:when test="current()[name()='id' and ($id!='' or text()='$id$')]">
        <xsl:copy>
          <xsl:value-of select="$id"/>
        </xsl:copy>
      </xsl:when>
      <xsl:when test="current()[name()='version' and ($version!='' or text()='$version$')]">
        <xsl:copy>
          <xsl:value-of select="$version"/>
        </xsl:copy>
      </xsl:when>
      <xsl:when test="current()[name()='title' and (text()='' or text()='$title$') and ($title!='')]">
        <xsl:copy>
          <xsl:value-of select="$title"/>
        </xsl:copy>
      </xsl:when>
      <xsl:when test="current()[name()='authors' and ($authors!='' or text()='$author$')]">
        <xsl:copy>
          <xsl:value-of select="$authors"/>
        </xsl:copy>
      </xsl:when>
      <xsl:when test="current()[name()='owners' and ($owners!='' or text()='$author$')]">
        <xsl:copy>
          <xsl:value-of select="$owners"/>
        </xsl:copy>
      </xsl:when>
      <xsl:when test="current()[name()='description' and ($description!='' or text()='$description$')]">
        <xsl:copy>
          <xsl:value-of select="$description"/>
        </xsl:copy>
      </xsl:when>
      <xsl:when test="current()[name()='files']">
        <xsl:element name="files">
          <xsl:value-of select="$newline"/>
          <xsl:if test="$build!=''">
            <xsl:call-template name="split">
              <xsl:with-param name="value" select="$build"/>
              <xsl:with-param name="files" select="*"/>
            </xsl:call-template>
          </xsl:if>
          <xsl:if test="$content!=''">
            <xsl:call-template name="split">
              <xsl:with-param name="value" select="$content"/>
              <xsl:with-param name="files" select="*"/>
            </xsl:call-template>
          </xsl:if>
          <xsl:if test="$lib!=''">
            <xsl:call-template name="split">
              <xsl:with-param name="value" select="$lib"/>
              <xsl:with-param name="files" select="*"/>
            </xsl:call-template>
          </xsl:if>
          <xsl:if test="$tools!=''">
            <xsl:call-template name="split">
              <xsl:with-param name="value" select="$tools"/>
              <xsl:with-param name="files" select="*"/>
            </xsl:call-template>
          </xsl:if>
          <xsl:for-each select="*">
            <xsl:value-of select="concat($tab, $tab)"/>
            <xsl:copy>
              <xsl:apply-templates select="node()|@*"/>
            </xsl:copy>
            <xsl:value-of select="$newline"/>
          </xsl:for-each>
          <xsl:value-of select="$tab"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="split">
    <xsl:param name="value" select="."/>
    <xsl:param name="files"/>
    <xsl:param name="name" select="'file'"/>

    <xsl:if test="string-length($value) > 0">
      <xsl:variable name="nextItem" select="substring-before(concat($value, ';'), ';')"/>
      <xsl:variable name="exists" select="$files/@src = $nextItem"/>

      <xsl:if test="not($exists)">
        <xsl:value-of select="concat($tab, $tab)"/>
        <xsl:element name="{$name}">
          <xsl:attribute name="src">
            <xsl:value-of select="$nextItem"/>
          </xsl:attribute>
          <xsl:attribute name="target">
            <xsl:value-of select="$nextItem"/>
          </xsl:attribute>
        </xsl:element>
        <xsl:value-of select="$newline"/>
      </xsl:if>
      
      <xsl:call-template name="split">
        <xsl:with-param name="value" select="substring-after($value, ';')"/>
        <xsl:with-param name="files" select="$files"/>
        <xsl:with-param name="name" select="$name"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
