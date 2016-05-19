class EmailBuilderService
  attr_reader :template
  def initialize(template)
    @template = template
    create_email
  end

  def create_email
    create = CreateEmail.new(@template)
    create.email_string
  end
end
