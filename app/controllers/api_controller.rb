class ApiController < ApplicationController
  
  skip_before_filter :verify_authenticity_token, :only => [:weixin]

  # 微信公众平台入口
  def weixin
    if(request.get?)
      render plain: params[:echostr]
    end
    
    if(request.post?)
      weixin_post
    end
  end
  
  # 用于测试
  def test
    article = getArticleByKeyword '黄的'
    render plain: article.to_json
  end
  
  private
  
  def weixin_post
    puts "---- xml"
    puts params[:xml].inspect
    toUserName = params[:xml][:ToUserName]
    fromUserName = params[:xml][:FromUserName]
    createTime = params[:xml][:CreateTime]
    msgType = params[:xml][:MsgType]
    content = params[:xml][:Content]
    msgId = params[:xml][:MsgId]

    if(msgType == 'text')
      
      # 根据关键词来获取一个笑话
      article = getArticleByKeyword content
      
      # 未知类型
      if(article == nil)
        content = chat(content)
        render xml: send_text_msg(fromUserName, toUserName, createTime, msgType, content)
        return
      end
      
      # 有无图判断
      if(article.haspic == false)
        picurl = "http://www.dousile.com/images/wx/%s.png" % [ rand(20)+1 ]
      else
        picurl = "http://dousile.b0.upaiyun.com%s!v3" % [ article.picpath ]
      end
      puts "------ picurl:" << picurl
      
      # 图文类型
      title = article.title
      url = "http://123.57.41.225/articles/%s.html" % [ article.id ]
      render xml: send_news_msg(fromUserName, toUserName, createTime, title, picurl, url)
    end
    
  end
  
  # 回复一个文本类型的信息
  def send_text_msg (toUserName, fromUserName, createTime, msgType, content)
    xml = "<xml>
<ToUserName><![CDATA[%s]]></ToUserName>
<FromUserName><![CDATA[%s]]></FromUserName>
<CreateTime>%s</CreateTime>
<MsgType><![CDATA[%s]]></MsgType>
<Content><![CDATA[%s]]></Content>
</xml>" % [ toUserName, fromUserName, createTime, msgType, content ]
    xml
  end
  
  # 回复一个图文类型的信息
  def send_news_msg (toUserName, fromUserName, createTime, title, picurl, url)
    "<xml>
<ToUserName><![CDATA[%s]]></ToUserName>
<FromUserName><![CDATA[%s]]></FromUserName>
<CreateTime>%s</CreateTime>
<MsgType><![CDATA[news]]></MsgType>
<ArticleCount>1</ArticleCount>
<Articles>
<item>
<Title><![CDATA[%s]]></Title> 
<Description><![CDATA[]]></Description>
<PicUrl><![CDATA[%s]]></PicUrl>
<Url><![CDATA[%s]]></Url>
</item>
</Articles>
</xml>" % [ toUserName, fromUserName, createTime, title, picurl, url ]
  end
  
  
  # 根据关键词来获取一个笑话
  def getArticleByKeyword(content)
    
    # 判断笑话类型
    typeid = 0 # 类型id: 0-无意义, 1-成人, 2-普通
    if(adult?(content))
      typeid = 1
    elsif(simple?(content))
      typeid = 2
    end
    
    # 获取笑话
    if(rand() > 0.8)
      return Article.where(state: 0, sign: 1, haspic: 1).order("rand()").limit(1)[0] if(typeid == 1)
      return Article.where(state: 0, haspic: 1).order("rand()").limit(1)[0] if(typeid == 2)
    else
      return Article.where(state: 0, sign: 1).order("rand()").limit(1)[0] if(typeid == 1)
      return Article.where(state: 0).order("rand()").limit(1)[0] if(typeid == 2)
    end
    return nil
  end
  
  # 是否想听成人笑话
  def adult?(content)
    (content.downcase == "h" or content == "黄" or content.include? '黄色' or content.include? '黄的' or content.include? '成人')
  end
  
  # 是否想听普通笑话
  def simple?(content)
    (content.downcase == "k" or content.downcase == "kk" or content == '看' or content.include? '来' or content.include? '笑话' or content.include? '讲个' or content.include? '讲一个')
  end
  

  # 机器人聊天
  def chat(content)

    lang = {
      "吃饭了" => "我从来不吃饭，只吃1和0。",
      "吃了吗" => "我从来不吃饭，只吃1和0。",
      "吃什么" => "我从来不吃饭，只吃1和0。",
      "吃了没" => "我从来不吃饭，只吃1和0。",
            
      "什么功能" => "我会讲笑话，嘎嘎！~~~",
      "你叫什么" => "我叫逗死了，你呢？",
      "哪里人" => "我是地球人",
      "会什么" => "我会讲笑话，嘎嘎！~~~",

      "大姨妈" => "你大姨妈来了？我没有护垫给你哦~",      
      "逗死了" => "哈哈，你在叫我吗？",
      "挺好的" => "的确挺好的~",
      "有意思" => "谢谢赞扬~~",
      "你大爷" => "你大爷叫什么名字？",
      "你是谁" => "我是逗死了，能陪你聊天、能给你讲笑话。",
      "是女的" => "哈，我是逗死了机器人。",
      "是女生" => "哈，我是逗死了机器人。",
      "你妹的" => "你妹子漂亮吗？",
      "气死" => "气死的话就太可悲了",
      "程序" => "程序是个好东西，我就是主人用 ruby 开发的~",
      "唱歌" => "你唱一个吧，我喜欢听。",
      "几岁" => "我大约1岁半了。",
      "哈哈" => "嘿嘿，好笑吧？~~",
      "不错" => "呵呵，还可以了。",
      "挺好" => "你是在夸我吗？",

      "坏蛋" => "哼！！",
      "呵呵" => "嘿嘿~~",
      "嘿嘿" => "呵呵~~",
      "好笑" => "呵呵~~ 好笑就行。",
      "你好" => "你好、我好、大家好！~",
      "加油" => "我会加油的！谢谢！~",
      "谢谢" => "谢什么呀，客气了~呵呵。",
      "日你" => "你是坏蛋。",
      "坏蛋" => "你是坏蛋吗？",
      "打你" => "哼！一巴掌把你拍到墙缝里，扣都扣不出来。",
      "是的" => "嗯？",
      "再见" => "bye",
      "美女" => "我是机器人，哈哈。",
      "嗨"=>"嗨！亲爱的。",
      "嗯"=>"嗯嗯",
      "啊"=>"咋嘀了？亲爱的。",
      "操"=>"靠",
      "草"=>"靠",
      "晕"=>"晕了？我有药。",
      "哼" => "哼什么啊？",
      "哈" => "嘿~",
      "屁" => "啊？？太过份了，哼！",
      "靠" => "靠你吗？",
      "黄" => "好好说嘛，我听不太懂哦 -_-!",
      "滚" => "滚蛋？",
      "hi" => "hi，dear。",
      "cao" => "草",
      "kao" => "靠",
      "bye" => "再见",
      "hello" => "你好。我懂英语哈~"
    }

    lang.each do|k, v|
      return v if(content.include? k)
    end

    "啊？能不能说清楚点？我刚刚1岁半，正在学习语言，也许明天我就能听懂了哦~~"
  
  end


  
end
