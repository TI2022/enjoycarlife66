class Reservation < ApplicationRecord
  belongs_to :guest, class_name: 'User'
  belongs_to :staff, class_name: 'Staff'
  has_many :reviews, dependent: :destroy
  has_many :review_answers, dependent: :destroy
  validates :start_time, presence: true, reservation: true # reservation: trueを記述する事でreservation_validator.rbのエラー表示にカラム名を表示する。
  validates :end_time, presence: true
  validates :course, presence: true
  validates :comment, length: { maximum: 200 }
  validate :two_hours_later_on_the_day, on: :registration # お客さんのみ新規登録は当日の２時間後以降しか登録できない
  validate :reservations_can_be_made_up_to_10_days_in_advance, on: :registration  #お客さんのみ新規予約登録は10日後までできる
  validate :in_working_time
  validate :start_time_not_sunday
  
  def two_hours_later_on_the_day
    now = Time.current
    two_hours_later = now + 7200
    errors.add(:start_time, 'は、当日２時間後以降の予約ができます。') if start_time < two_hours_later
  end

  def reservations_can_be_made_up_to_10_days_in_advance
    errors.add(:start_time, 'は、10日後まで予約ができます。') if start_time > Time.current.since(10.days).at_end_of_day
  end

  def in_working_time
    errors.add(:start_time, 'は、19時以前の日時を入力して下さい。') if start_time.hour > 19
    errors.add(:start_time, 'は、10時以降の日時を入力して下さい。') if start_time.hour < 10
  end

  def start_time_not_sunday
    errors.add(:start_time, "は日曜日を選択できません") if start_time.sunday?
  end

  enum status: {
    status_default: 0, #未設定
    on_request: 1, #申込中
    on_reserve: 2, #予約確定
    completed: 3, #施術完了
  }

  #reservations_controller.rbのcreateアクションで使用
  def apply!(menu_time)
    end_time = start_time + menu_time
    self.assign_attributes(
      end_time: end_time,
      status: :on_request,
      title_for_guest: "仮予約",
      title_for_staff: "仮予約"
    )
  end

  #reservations_controller.rbのupdate_reserveアクションで使用
  def apply_update!(menu_time)
    end_time = start_time + menu_time
    self.update(
      end_time: end_time
    )
  end

  #reservations_controller.rbのmanagement_createアクションで使用
  def apply_management!(menu_time)
    end_time = start_time + menu_time
    title_for_staff_comment = "予約確定 #{self.guest.name}様  #{self.treatment_menu}  #{self.staff.name}"
    self.update(
      end_time: end_time,
      status: :on_reserve,
      title_for_guest: "予約確定",
      title_for_staff: title_for_staff_comment
    )
  end

  scope :from_today, -> () {
    where('start_time >= ?', Time.zone.now)
  }

  # #指定された配列日付のデータを抽出
  # scope :in_selected_days, -> (days) {
  #   where(arel_table[:treatment_day].in(days))
  # }

  # #指定された日付のデータを抽出
  # scope :in_selected_day, -> (day) {
  #   where(arel_table[:treatment_day].eq(day))
  # }

end
