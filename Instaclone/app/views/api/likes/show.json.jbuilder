json.extract! @like, :id, :user_id, :post_id
# json.likes post.likes.count
# json.liked_by_current_user !!post.likes.find_by(user_id: current_user.id)
