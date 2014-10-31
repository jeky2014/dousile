class ParsePosting

  # 解析字符串
  def parse(str)
    arr = []
    obj = nil
    str.each_line {|line|
      if(line.start_with?('==='))
        arr.push(formatJSON obj) if(obj != nil)
        obj = { }
        obj["title"] = formatTitle(line)
      else
        if(obj != nil)
          if(obj["content"] != nil)
            line = obj["content"] << (line)
          end
          obj["content"] = (line)
        end
      end
    }
    arr.push(formatJSON obj) if(obj != nil)
    arr
  end

  def formatJSON(obj)
    obj["title"] = formatTitle obj["title"]
    if(obj["title"].end_with? '*')
      obj["sign"] = 1
      obj["title"] = obj["title"].gsub(/(\*){1,}$/,'')
    else
      obj["sign"] = 0
    end
    obj["content"] = formatContent obj["content"]
    obj
  end

  def formatTitle(title)
    title.gsub(/^(=){3,}/, '').strip
  end

  def formatContent(content)
    content = content.strip.gsub(/\r\n/, '<br/>').gsub(',', '，').gsub('.', '。').gsub('?', '？').gsub('!', '！')
  end

end
