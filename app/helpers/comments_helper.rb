module CommentsHelper

  def unread_messages
    if current_user
      @unread_messages = Comment.where("been_read = ? AND send_to = ?", false, current_user.id)
    else
      @unread_messages = []
    end
  end

end
