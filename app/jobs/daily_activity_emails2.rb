module DailyActivityEmails2

  @queue = :daily_activity_emails_queue

  def self.perform()

    now = Date.today

    # interval of posts to consider
    if Rails.env.production?
      # utc time
      end_time   = DateTime.new(now.year, now.month, now.day, 24, 0, 0, 0)
      start_time = end_time.advance(:hours => -24)
    else
      end_time = DateTime.current
      start_time = end_time.advance(:minutes => -10)
    end

    # selects all networks that have updates created between <start_time> and <end_time>
    networks = Network.includes({:posts => :post_recipients}, :invitations).where(:posts => {
      :created_at => start_time..end_time})

    networks.each do |n|

      # {
      #   'user_email' => 
      #     {
      #       :first_name => 'First Name',
      #       :last_name  => 'Last Name',
      #       :token      => <invitation_token>,
      #       :posts      => Array
      #     }
      # }
      list = {}

      # network's posts
      n.posts.each do |p|

        # post's recipients (registered users)
        p.all_recipients.each do |r|

          list[r.email] = {
            :first_name => r.first_name,
            :last_name  => r.last_name,
            :posts      => []
          } unless list[r.email]

          list[r.email][:posts] << p

        end

        # network's invited users (not registered yet)
        n.invitations.each do |i|

          if p.is_visible_to_invited?
            list[i.email] = {
              :first_name => i.first_name,
              :last_name  => i.last_name,
              :token      => i.token,
              :posts      => []
            } unless list[i.email]

            list[i.email][:posts] << p
          end

        end

      end

      # TODO: send the emails
      #list.each do |email, u|
      #  puts ">> Would be sending #{u[:posts].size} to #{email} #{u[:token] ? 'invite' : 'member'}"
      #  UserMailer.daily_news_activity(u[:posts], email, u[:first_name], u[:last_name], n.network_for_who, u[:token]).deliver
      #end

    end

  end

end
