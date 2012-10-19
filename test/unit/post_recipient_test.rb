require 'test_helper'

class PostRecipientTest < ActiveSupport::TestCase
  test 'User from network create a post' do
    # create a Network
    @n1 = Network.new(network_name: "Skype", network_for_who: "My father")
    @n1.save!
    # create the first user
    @creator = @n1.users.new(email:"dummy@rocket.com", role: "Initiator", first_name: "The", last_name: "master", network_relationship: "son", password: "123456" )
    @creator.save!
    # make 1 coordinator
    @coord = @n1.users.new(email:"dummy2@rocket.com", role: "Coordinator", first_name: "coord", last_name: "the", network_relationship: "top dog", password: "123456" )
    @coord.save!
    # make 1 somebody
    @dude1 = @n1.users.new(email:"dummy3@rocket.com", role: "", first_name: "dude", last_name: "the", network_relationship: "dude", password: "123456" )
    @dude1.save!
    # make 1 doc
    @doc =   @n1.users.new(email:"dummy4@rocket.com", role: "", first_name: "doc", last_name: "the", network_relationship: "doctor", password: "123456" )
    @doc.save!
    
    # a second network
    @n2 = Network.new(network_name: "Skynet", network_for_who: "Darth Vader")
    @n2.save!
    # a dude from other network
    @foreigner = @n2.users.new(email:"dummy5@rocket.com", role: "", first_name: "spy", last_name: "the", network_relationship: "no good", password: "123456" )
    @foreigner.save!

    #http://guides.rubyonrails.org/testing.html#assertions-available
    
    # @creator makes a post for everyone in @n1
    Post.transaction do
      @public_post = Post.new({content: "YADA YADA YADA YADA"})
      @public_post.network_id = @creator.network_id
      @public_post.user_id = @creator.id
      @public_post.save!
      PostRecipient.create!(post_id: @public_post.id, user_id: 0)
    end

    # @doc makes a post for only @dude1 to see
    Post.transaction do
      @post2 = Post.new({content: "YADA YADA YADA YADA"})
      @post2.network_id = @doc.network_id
      @post2.user_id = @doc.id
      @post2.save!
      PostRecipient.create!(post_id: @post2.id, user_id: @doc.id)
      PostRecipient.create!(post_id: @post2.id, user_id: @dude1.id)
    end

    # can only people in network see the post?
    posts_coord = @coord.network.posts.visible_to(@coord)
    posts_dude1 = @dude1.network.posts.visible_to(@dude1)
    posts_foreigner = @foreigner.network.posts.visible_to(@foreigner)

    pass = (posts_coord.map &:id).include?(@public_post.id)
    pass = pass && (posts_dude1.map &:id).include?(@public_post.id)
    pass = pass && !(posts_foreigner.map &:id).include?(@public_post.id)
    assert pass, "post should be visible in network and only inside it"


    # on a 1 x 1 post, only them both should se it
    posts_coord = @coord.network.posts.visible_to(@coord)
    posts_doc = @doc.network.posts.visible_to(@doc)
    posts_creator = @creator.network.posts.visible_to(@creator)
    posts_dude1 = @dude1.network.posts.visible_to(@dude1)
    posts_foreigner = @foreigner.network.posts.visible_to(@foreigner)

    pass = !(posts_coord.map &:id).include?(@post2.id)
    pass = pass && !(posts_creator.map &:id).include?(@post2.id)
    pass = pass && (posts_doc.map &:id).include?(@post2.id)
    pass = pass && (posts_dude1.map &:id).include?(@post2.id)
    pass = pass && !(posts_foreigner.map &:id).include?(@post2.id)
    assert pass, "post with only 2 recipients, should be private to those"
  end
end
