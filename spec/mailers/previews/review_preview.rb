# Preview all emails at http://localhost:3000/rails/mailers/review
class ReviewPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/review/review_notification
  def review_notification
    ReviewMailer.review_notification
  end

end
