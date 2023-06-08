class Message
  attr_accessor :id, :sender_id, :receiver_id, :content, :created_at

  def initialize(attributes = {})
    @id = attributes['id']
    @sender_id = attributes['sender_id']
    @receiver_id = attributes['receiver_id']
    @content = attributes['content']
    @created_at = attributes['created_at']
  end
end
