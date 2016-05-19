class CreateEmail
  attr_accessor :email_body, :email_string
  def initialize(template)
    @email_body = template[:emailBody]
    @email_string = ''
    create_td
  end

  def create_td
    emailArr = []
    email_body.each do |_, value|
      imageSize = FastImage.size(value[:image])
      td = %(<a href="#{value[:ahref]}" target="_blank"><img src="#{value[:image]}" alt="#{value[:altTag]}" align="left" width="#{imageSize[0]}"height="#{imageSize[1]}" style="display: block; float: left; margin: 0; text-align: left; border: 0;"></a>)
      emailArr.push(td)
    end
    stringify_email(emailArr)
  end

  def stringify_email(emailArr)
    emailString = ''
    emailArr.each do |td|
      emailString += td + "\n"
    end
    build_email(emailString)
  end

  def build_email(emailString)
    top = %(<table cellpadding="0" cellspacing="0" border="0" align="center" width="600"><tr><td style="min-width: 600px">)
    bottom = %(</td></tr></table>)
    email = top + emailString + bottom
    email_string = email
  end
end
