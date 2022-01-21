class ReviewAnswersController < ApplicationController
  skip_before_action :authenticate_user!

  def new
    @review = Review.find_by(review_exists: true)
    @reservation = @review.reservation
    @review_answer = ReviewAnswer.new
  end

  def create
    @review_answer = ReviewAnswer.new(review_answer_params)
    @review = Review.find_by(review_exists: true)
    @review_id = @review.id
    @review_answers.staff_id = current_staff.id
    if @review_answer.save
      redirect_to reservation_reviews_url
      flash[:success] = "投稿に成功しました"
    else
      render :new
      flash[:danger] = "投稿に失敗しました、入力項目を確認してください。"
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
    def review_answer_params
      params.require(:review_answer).permit(:staff_name, :content, :review_id, :staff_id)
    end
end
