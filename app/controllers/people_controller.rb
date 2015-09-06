get '/people' do
  @people = Person.all
  erb :"/people/index"
end

post '/people' do
  
  if params[:birthdate].include?("-")
        birthdate = params[:birthdate]
      else
        puts "-*" * 30
        puts params[:birthdate]
        puts "-*" * 30
        # birthdate = Date.strptime(params[:birthdate], "%m%d%Y")
  end
  
  # birthdate = params[:birthdate]
  
      @person = Person.new(first_name: params[:first_name], last_name: params[:last_name], birthdate: birthdate)
      if @person.valid?
        @person.save
        redirect "/people/#{@person.id}"
      else
        @error = "The data you entered isn't valid:"
        @errors = ''
        @person.errors.full_messages.each do |message|
          @errors = "#{@errors} #{message}. <br />"
        end
        erb :"/people/new"
      end
  end

get '/people/new' do
  @person = Person.new
  # @person.birthdate = Date.strptime("{ 0001, 01, 01 }", "{ %Y, %m, %d }")
  erb :"/people/new"
end

get '/people/:id' do
  @person = Person.find(params[:id])
  birthdate_string = @person.birthdate.strftime("%m%d%Y")
  puts birthdate_string
  birthpath_num = Person.get_birth_path_num(birthdate_string)
  puts birthpath_num
  @message = Person.get_message(birthpath_num)
  erb :"/people/show"
end

# get '/people/:id' do
#   @person = Person.find(params[:id])
#   birthdate_string = @person.birthdate.strftime("%m%d%Y")
#   puts birthdate_string
#   birthpath_num = Person.get_birth_path_num(birthdate_string)
#   puts birthpath_num
#   @message = Person.get_message(birthpath_num)
#   erb :"/people/show"
# end

delete '/people/:id' do
  person = Person.find(params[:id])
  person.destroy
  redirect "/people"
end

get '/people/:id/edit' do
  @person = Person.find(params[:id])
  erb :'/people/edit'
end

put '/people/:id' do
  person = Person.find(params[:id])
  person.birthdate = params[:birthdate]
  person.save
  redirect "/people/#{person.id}"
end

