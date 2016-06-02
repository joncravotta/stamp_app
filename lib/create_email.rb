require 'fastimage'

class CreateEmail
  attr_accessor :email_body, :email
  def initialize(template)
    @email_body = template
    @email = ''
    create_td
  end

  def create_td
    email_arr = []
    puts 'email body'
    puts (email_body)
    # error if emailBody is empty
    email_body['emailBody'].each do |_, value|
      puts value
      image_size = FastImage.size(value[:image])
      # error if cant retrieve image size
      td = %(<a href="#{value[:ahref]}" target="_blank"><img src="#{value[:image]}" alt="#{value[:altTag]}" align="left" width="#{image_size[0]}"height="#{image_size[1]}" style="display: block; float: left; margin: 0; text-align: left; border: 0;"></a>)
      email_arr.push(td)
    end
    stringify_email(email_arr)
  end

  def stringify_email(email_arr)
    email_string = ''
    email_arr.each do |td|
      email_string += td
    end
    build_email(email_string)
  end

  def build_email(email_string)
    top = %(<table cellpadding="0" cellspacing="0" border="0" align="center" width="600"><tr><td style="min-width: 600px">)
    bottom = %(</td></tr></table>)
    @email = top + email_string + bottom
  end
end
