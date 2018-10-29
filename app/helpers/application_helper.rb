module ApplicationHelper
  def paginate(objects, options = {})
    options.reverse_merge!(theme: 'twitter-bootstrap-3')

    super(objects, options)
  end

  def admin?
    current_user && current_user.role.admin?
  end
end
