    require 'rubygems'
    require 'sinatra'
    require 'twilio-ruby'
    require 'stringio'
    require 'stringio'
    require 'forwardable'
         
    post '/transcribenew' do
    account_sid = 'ACCOUNT_SID'
    auth_token = 'ACCOUNT_AUTHEN_TOKEN'
    @client = Twilio::REST::Client.new account_sid, auth_token
    @transcription = @client.account.transcriptions.get(params['TranscriptionSid'])
     
    puts @transcription.transcription_text
    str = @transcription.transcription_text
=begin
    temp= Array.new
    words= str.split(" ")
    i=0
    for num in 0...words.length
            if words[num]>='0' && words[num]<='9'
                    if num>0
                            if words[num-1]>'9'
                                    temp[i]=words[num-1]
                                    i=i+1
                            end
                            temp[i]=words[num]
                            i=i+1
                    end               
       if num+1<words.length && words[num+1]>'9'
                           # print "Facebook"                                               
                            temp[i]=words[num+1]
                    end
          

            end
    end
    print words
    print temp
     
     
    st=temp[0]
    for v in 1...temp.length
            if temp[v]>='0' && temp[v]<='9' && temp[v-1]>'9'       
                    st= st+' '+temp[v]
            else if temp[v]>'9' && temp[v]>='0' && temp[v-1]<='9'
            st= st+' '+temp[v]
            else
                    st= st+temp[v]
            end
    end
    end
     
    print st 
=end     
    #puts @transcription.transcription_text
    #str = @transcription.transcription_text
     
   
     
  	temp= Array.new
    words= str.split(" ")
    i=0
     
    for num in 0...words.length
     
    if words[num] == "is" && num <= words.length-3 && words[i+1] > '9'
     
        #if words[i+1] > '9'
            temp[i] = "Name:"
            i = i+1
            temp[i] = words[num+1]
            i = i + 1
            temp[i] = words[num+2]
            i = i + 1
       
    elsif words[num] == "is" && words[i+1] >= '0' && words[i+1] <= '9'
            temp[i] = "Number:"
            i = i+1
       # end
=begin
            temp[i] = "Name:"
            i = i + 1
            temp[i] = words[num+1]
            i = i + 1
            temp[i] = words[num+2]
            i = i + 1
     
        elsif words[num] == "number" && num <= words.length-3
            temp[i] = "Number:"
            i = i+1
=end
           
    elsif words[num] == "at"
            temp[i] = "at"
            i = i + 1
       
    elsif words[num] == "calling"
        temp[i] = "Number"
        i = i+1
       
    elsif words[num] >= '0' && words[num] <='9'
            temp[i] = words[num]
            i = i + 1
        end
    end
     
     
     
     
    #end
     
    print temp
     
     
    # concatenation code below
     
    st=temp[0]
    for v in 1...temp.length
            if temp[v]>='0' && temp[v]<='9' && temp[v-1]>'9'       
                    st= st+' '+temp[v]
            else if temp[v]>'9' && temp[v]>='0' && temp[v-1]<='9'
            st= st+' '+temp[v]
     
            else if temp[v]>'9' && temp[v-1] > '9'
                    st = st + ' ' + temp[v]
            else
                    st= st+temp[v]
            end
    end
    end
    end
     
    print st
     
     
     
     
     
     
     
     
    #This everything else, DO NOT TOUCH !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     
     
    @client.account.messages.create(
    :from => 'YOUR_TWILIO_NUMBER',
    :to => 'YOUR_PHONE_NUMBER',#params['From'],
    :body => st)#params['TranscriptionText'])
     
    #@transcription = @client.account.transcriptions.get(params['TranscriptionSid'])
    #puts @transcription.transcription_text
    #puts msg.inspect
     
    end
         
    get '/hello-monkey' do
    
=begin
    people = {
    '+14158675309' => 'Curious George',
    '+14158675310' => 'Boots',
    '+14158675311' => 'Virgil',
    '+14158675312' => 'Marcel',
    }
=end
    #name = people[params['From']] || 'Monkey'
    Twilio::TwiML::Response.new do |r|
    r.Say "Hello, please leave me a message with your full name and phone number."
     
    r.Gather :numDigits => '1', :action => '/hello-monkey/handle-gather', :method => 'get' do |g|
    g.Say 'To leave a message, press 2.'
    #g.Say 'I cannot .'
    #g.Say 'Press any other key to start over.'
             end
            end.text
            end
    get '/hello-monkey/handle-gather' do
            redirect '/hello-monkey' unless ['1', '2'].include?(params['Digits'])
            if params['Digits'] == '1'
                    response = Twilio::TwiML::Response.new do |r|
                #       r.Dial '+13105551212'
                    r.Say 'Goodbye.'
            end
            elsif params['Digits'] == '2'
                    response = Twilio::TwiML::Response.new do |r|
                    r.Say 'Record your message after the tone.'
                    r.Record :maxLength => '119', :action => '/hello-monkey/handle-record', :method => 'get',:transcribe => 'true', :transcribeCallback => '/transcribenew'
     
            end
    end
    response.text
    end
         
    get '/hello-monkey/handle-record' do
    resp = Twilio::TwiML::Response.new do |r|
    r.Say 'Listen to your message.'
    r.Play params['RecordingUrl']
    r.Say 'Goodbye.'
    end
    resp.text
    end


