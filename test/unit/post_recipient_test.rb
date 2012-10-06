require 'test_helper'

class PostRecipientTest < ActiveSupport::TestCase
  test 'User from network create a post' do
    # create a Network
    @n = Network.new(network_name: "Skype", network_for_who: "My father")
    @n.save!
    # create the first user
    @creator = @n.users.new(email:"dummy@rocket.com", role: "Initiator", first_name: "The", last_name: "master", network_relationship: "son", password: "123456" )
    @creator.save!
    # make 1 coordinator
    @coord = @n.users.new(email:"dummy2@rocket.com", role: "Coordinator", first_name: "coord", last_name: "the", network_relationship: "top dog", password: "123456" )
    @coord.save!
    # make 1 somebody
    @dude1 = @n.users.new(email:"dummy3@rocket.com", role: "", first_name: "dude", last_name: "the", network_relationship: "dude", password: "123456" )
    @dude1.save!
    # make 1 doc
    @doc =   @n.users.new(email:"dummy4@rocket.com", role: "", first_name: "doc", last_name: "the", network_relationship: "doctor", password: "123456" )
    @doc.save!
    
    # a second network
    @n2 = Network.new(network_name: "Skynet", network_for_who: "Darth Vader")
    @n2.save!
    # a dude from other network
    @foreigner = @n.users.new(email:"dummy5@rocket.com", role: "", first_name: "spy", last_name: "the", network_relationship: "no good", password: "123456" )
    @foreigner.save!

    #http://guides.rubyonrails.org/testing.html#assertions-available
    # coord wants to publish a message for everyone on his net.
    
  end
end
