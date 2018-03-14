<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
  <html>
    <head><title>CDAA Report for: <xsl:value-of select="ConfigData/AppxFile"/></title>
      <style>
        h1 {
          font-weight: normal;
        }
        h1, h2, p, td, th {
          font-family: "Calibri Light",Calibri,Candara,Segoe,Segoe UI,Optima,Arial,sans-serif;
        }
        .critical {
          color: red;
        }
        .success {
          color: black;
          font-weight: bold;
        }
        td.success {
          color: black;
          background-color: #66FF33;
        }
        td.warning {
          background-color: #FFFF00;
        }
        td.critical {
          color: black;
          background-color: #CC0000;
        }
        .resultValue td {
          color: yellow;
          background-color: grey;
        }
        .mitigation td {
          color: black;
          #background-color: #FF9933;
        }
        .appdata th {
          text-align: left;
          font-weight: normal;
        }
        .appdata td {
          text-align: left;
          font-weight: bold;
        }
        .resulttable td {
          border: 1px solid black;
        }
        .resulttable tr th {
          background-color: #3399FF;
        }
      </style>
    </head>
    <body style="width:80%;padding-left:20px">
      <h1>Converted Desktop App Analysis (CDAA)</h1>
      <table class="appdata">
        <tr><th>App Name</th><td><xsl:value-of select="ConfigData/AppxFile/@Name"/></td></tr>
        <tr><th>Publisher Info</th><td><xsl:value-of select="ConfigData/AppxFile/@Publisher"/></td></tr>
        <tr><th>Appx Filename</th><td><xsl:value-of select="ConfigData/AppxFile"/></td></tr>
        <tr><th>App Version</th><td><xsl:value-of select="ConfigData/AppxFile/@Version"/></td></tr>
        <tr><th>Windows Version</th><td><xsl:value-of select="ConfigData/Report/WindowsVersion"/></td></tr>
        <tr><th>Windows Architecture</th><td><xsl:value-of select="ConfigData/Report/ProcessorArchitecture"/></td></tr>
        <tr><th>Windows SKU</th><td><xsl:value-of select="ConfigData/Report/WindowsSku"/></td></tr>
        <tr><th>Report Generation Time</th><td><xsl:value-of select="ConfigData/Report/@CreateDate"/></td></tr>
        <tr><th>CDAA Version</th><td><xsl:value-of select="ConfigData/Report/CdaaVersion"/></td></tr>
        <tr><th>CDAA Input</th><td><xsl:value-of select="ConfigData/Report/InvokeParams"/></td></tr>
      </table>
      <hr></hr>
      <h2>Overall Assessment:
        <xsl:variable name="failcount" select="count(/ConfigData/Flows/Flow/Rules/Rule/Result[Passed='false'])" />
        <xsl:choose>
          <xsl:when test="$failcount > 0" >
            <font class="critical">Critical issues detected (<xsl:value-of select="$failcount"/>)</font>
            <table class="resulttable">
              <tr><th>Service</th><th>Rule</th></tr>
              <xsl:for-each select="ConfigData/Flows/Flow/Rules/Rule[Result/Passed = 'false']">
                    <tr>
                      <td><xsl:value-of select="ServiceType"/></td>
                      <td><xsl:value-of select="RuleDesc"/></td>
                    </tr>
              </xsl:for-each>
            </table>
          </xsl:when>
          <xsl:otherwise>
            <font class="success">No critical issues detected</font>
          </xsl:otherwise>
        </xsl:choose>
      </h2>
      <h1>Full Report</h1>
      <xsl:for-each select="ConfigData/Flows/Flow">
        <h2>FLOW:<xsl:value-of select="@Description"/></h2>
        <table class="resulttable">
          <tr>
            <th>Service</th>
            <th>Rule</th>
            <th>Result</th>
          </tr>
          <xsl:for-each select="Rules/Rule">
            <tr>
              <td><xsl:value-of select="ServiceType"/></td>
              <td><xsl:value-of select="RuleDesc"/></td>
                <xsl:choose>
                  <xsl:when test="Result/Passed = 'true'">
                    <td class="success">Passed</td>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:choose>
                      <xsl:when test="RuleSeverity = 'Failure'">
                        <td class="critical">
                          <xsl:value-of select="RuleSeverity"/>
                        </td>
                      </xsl:when>
                      <xsl:otherwise>
                        <td class="warning">
                          <xsl:value-of select="RuleSeverity"/>
                        </td>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:otherwise>
                </xsl:choose>
              </tr>
              <xsl:choose><xsl:when test="Result/Passed = 'false'">
                <tr class="mitigation">
		              <td>Mitigation</td>
		              <td colspan="3">
                    <xsl:value-of select="Mitigation" disable-output-escaping="yes"/>
                  </td>
                </tr>
                <tr class="resultValue">
                    <td colspan="4"><pre><xsl:value-of select="Result/Value"/></pre></td>
                </tr>
              </xsl:when>
              </xsl:choose>
          </xsl:for-each>
        </table>
      </xsl:for-each>
    </body>
  </html>
</xsl:template>
</xsl:stylesheet>
