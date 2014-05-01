<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:include href="main.xsl"/>
  <xsl:template match="page" mode="body">
    <div class="two-column">
      <div>
        <img src="../images/tea.svg"/>
      </div>
      <div>
        <div class="brand large">{reusable}</div>
        <ul class="menu menu-vertical darker medium vertical-padding">
          <li>
            <a href="">getting started</a>
          </li>
          <li>
            <a href="">components</a>
          </li>
          <li>
            <a href="">build your styles</a>
          </li>
          <li>
            <a href="">documentation</a>
          </li>
        </ul>
        <button class="button-success f-span6" onclick="location.href='controls'">GET STARTED</button>
        <p class="vertical-padding darker">
          Flat CSS framework with lots of reusable components and layouts
          that are extremely easy to use in your website
        </p>
      </div>
    </div>
  </xsl:template>
</xsl:stylesheet>