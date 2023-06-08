require_relative '../models/message'

class MessageRepository
  def self.create_notification(sender_id, receiver_id, content)
    # Assuming you have a 'notifications' column in the 'messages' table to differentiate notifications
    query = 'INSERT INTO messages (sender_id, receiver_id, content, is_notification) VALUES ($1, $2, $3, true);'
    params = [sender_id, receiver_id, content]
    DatabaseConnection.exec_params(query, params)
    nil
  end

  def self.find_notifications(user_id)
    query = 'SELECT * FROM messages WHERE receiver_id = $1 AND is_notification = true ORDER BY created_at DESC;'
    params = [user_id]
    result = DatabaseConnection.exec_params(query, params)

    notifications = []
    result.each do |row|
      notification = Message.new
      notification.id = row['id'].to_i
      notification.sender_id = row['sender_id'].to_i
      notification.receiver_id = row['receiver_id'].to_i
      notification.content = row['content']
      notification.created_at = row['created_at']
      notifications << notification
    end

    notifications
  end

end
