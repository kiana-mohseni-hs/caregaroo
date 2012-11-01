module ApplicationHelper
  
  def relationship_in_parenthesis(user, network_id)
    if user.present? and network_id.present? and user.network_relationship(network_id).present?
      "(" + user.network_relationship(network_id) + ")"
    else
      ""
    end
  end
  
end
