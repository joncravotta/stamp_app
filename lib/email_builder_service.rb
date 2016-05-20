class EmailBuilderService
  attr_reader :template, :response
  def initialize(template)
    @template = template
    @response = ''
    create_email
  end

  def create_email
    create = CreateEmail.new(@template)
    @response = create.email
    puts @response
  end
end
