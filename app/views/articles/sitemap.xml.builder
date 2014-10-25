xml.instruct!
xml.urlset("xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance", "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9", "xsi:schemaLocation" => "http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd") {
  xml.url {
    xml.loc "http://www.dousile.com/"
    xml.changefreq "daily"
    xml.priority "0.9"
  }
  for atc in @articles
  xml.url {
    xml.loc "http://www.dousile.com/detail/" + atc.id.to_s + ".html"
    xml.changefreq "daily"
    xml.priority "0.7"
  }
  end
}