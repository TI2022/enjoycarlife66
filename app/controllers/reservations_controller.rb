class ReservationsController < ApplicationController
  skip_before_action :authenticate_user! #スタッフは全てのアクションにアクセスできる
  skip_before_action :authenticate_staff!, only: [:index, :show, :new, :create] #ログイン済みユーザーは{index,show,new,create}アクションのみアクセスできる
  before_action :set_reservations, only: [:index, :confirm_reservation]
  before_action :set_reservation, only: [:show, :edit, :update, :edit_reserve, :update_reserve, :cancel_reserve, :destroy]
  before_action :set_menus, only: [:edit_reserve, :update_reserve, :management_new]
  before_action :set_users, only: :management_new
  before_action :reservation_completed, only: [:index, :confirm_reservation] # :end_timeが現在時刻を過ぎているデータは:statusをcompleted(施術完了)にする
  before_action :set_q, only: [:reservation_management, :search]
  before_action :set_new, only: [:management_new, :validate_new, :new]
  before_action :set_staffs, only: [:management_new, :edit_reserve, :update_reserve]
  before_action :set_month, only: :index
  before_action :logged_in_user, only: :show
  before_action :correct_user, only: :show

  # スタッフ予約管理画面
  def reservation_management
    @search_reservations = @q.result
  end

  # スタッフ予約管理画面（検索後画面）
  def search
    @search_reservations = @q.result
  end

  # スタッフが新規予約作成する画面
  def management_new
    @courses = @menus.where.not(category_number: "4").where.not(category_number: "3")
    @add_nail_menus = @menus.where(reserve_flag: "0").where(category_title_number: "4") # 予約メニューに表示する、巻き爪補正メニュー
    @topping_menus = @menus.where(category_number: "3") # トッピングメニュー
  end

  # スタッフが新規予約作成する処理
  def management_create
    @reservation = Reservation.new(reservation_params)
    menu = Menu.find(reservation_params[:course]) unless reservation_params[:course].blank?
    add_nail_number_menu = Menu.find(reservation_params[:add_nail_number_menu]) unless reservation_params[:add_nail_number_menu].blank?
    topping_number_menu = Menu.find(reservation_params[:topping_number_menu]) unless reservation_params[:topping_number_menu].blank?

    if menu.present?
      if topping_number_menu.present?
        menu_time = 60 * (menu.treatment_time + topping_number_menu.treatment_time + 10) # end_time登録の為に使用。インターバルタイムを10分追加した時間でend_timeを登録
      else
        menu_time = 60 * (menu.treatment_time + 10) # end_time登録の為に使用。インターバルタイムを10分追加した時間でend_timeを登録
      end
      @reservation.treatment_menu = menu.full_title
      @reservation.treatment_time_menu = menu.treatment_time
      @reservation.topping_menu = topping_number_menu.title if topping_number_menu.present?
      @reservation.charge_menu = menu.charge
      @reservation.add_nail_count_menu = add_nail_number_menu.add_nail_count if add_nail_number_menu.present?
      
      if topping_number_menu.present? && add_nail_number_menu.present?                           #トッピングあり && 巻き爪補正あり
        @reservation.full_charge_menu = menu.charge + topping_number_menu.charge + add_nail_number_menu.charge 
      elsif add_nail_number_menu.present? && !topping_number_menu.present?                      #トッピングなし && 巻き爪補正あり
        @reservation.full_charge_menu = menu.charge + add_nail_number_menu.charge
      elsif topping_number_menu.present? && !add_nail_number_menu.present?                      #トッピングあり、巻き爪補正なし
        @reservation.full_charge_menu = menu.charge + topping_number_menu.charge
      else                                                                                       #トッピングなし、巻き爪補正なし
        @reservation.full_charge_menu = menu.charge
      end
      @reservation.apply_management!(menu_time)
    end
    if @reservation.save
      user = User.find(@reservation.guest_id)
      #申込したゲストへのメール
      # UserMailer.request_reservation(user, @reservation).deliver_now
      #スタッフへのメール
      # UserMailer.request_reservation_staff(user, @reservation).deliver_now
      flash[:success] = "新規予約作成完了しました。"
      redirect_to reservation_management_reservations_url
    end
  end

  # スタッフが新規予約作成する画面
  def validate_new
  end

  # スタッフが新規予約作成する処理
  def validate_create
    @reservation = Reservation.new(reservation_params)
    @reservation[:validate_flag] = "1"
    title_for_staff_comment = "予約制限"
    @reservation[:title_for_staff] = title_for_staff_comment
    if @reservation.save
      flash[:success] = "予約制限作成を完了しました。"
      redirect_to reservation_management_reservations_url
    end
  end

  def index
    @current_guest_reservations = Reservation.where(guest_id: current_user.id).where(cancel_flag: 0).where(status: "on_request") if user_signed_in?
    @shifts = Shift.all
  end

  # 申し込み確認画面（スタッフ用）
  def confirm_reservation
    @shifts = Shift.all
    @reservations_on_request = Reservation.on_request.from_today.includes(:guest)
    @reservations_on_reserve = Reservation.on_reserve.from_today.includes(:guest)
    respond_to do |format|
      format.html
      format.json { @reservations }
    end
  end

  def show
  end

  def new
    @first_time_guests = Reservation.where(guest_id: current_user.id).where(cancel_flag: 0)
    now = Time.current
    from = now.ago(2.month).at_beginning_of_day
    to = now.since(10.days).at_end_of_day
    @guests_within_two_weeks = Reservation.where(guest_id: current_user.id).where(cancel_flag: 0).where(start_time: from...to)
    menu = Menu.where(reserve_flag: 0) # 予約画面に表示するメニューはreserve_flag: 0のものだけ。
    @first_menu = menu.where(category_title_number: "1") # 初回メニュー
    @change_nail_menu = menu.where(category_title_number: "8") # ２ヶ月以内来店巻き爪補正単品メニュー
    @special_menu = menu.where(category_title_number: "3") # ２ヶ月以内来店スペシャル割引メニュー

    @foot_menu = menu.where(category_title_number: "2") # フットケアメニュー
    @body_menu = menu.where(category_number: "2") # ボディケアメニュー
    @add_menu = menu.where.not(category_title_number: 1..9) # 追加したメニュー
    @DM_menu = menu.where(category_title_number: "7") # DMメニュー

    @topping_menu = menu.where(category_number: "3") # トッピングメニュー
    @add_nail_menu = menu.where(category_number: "4").where(category_title_number: "4") # 巻き爪補正メニュー
    
  end

  def create
    @reservation = Reservation.new(reservation_params)
    menu = Menu.find(reservation_params[:course]) unless reservation_params[:course].blank?
    add_nail_number_menu = Menu.find(reservation_params[:add_nail_number_menu]) unless reservation_params[:add_nail_number_menu].blank?
    topping_number_menu = Menu.find(reservation_params[:topping_number_menu]) unless reservation_params[:topping_number_menu].blank?

    if menu.present?
      if topping_number_menu.present?
        menu_time = 60 * (menu.treatment_time + topping_number_menu.treatment_time + 10) # end_time登録の為に使用。インターバルタイムを10分追加した時間でend_timeを登録
      else
        menu_time = 60 * (menu.treatment_time + 10) # end_time登録の為に使用。インターバルタイムを10分追加した時間でend_timeを登録
      end
      @reservation.treatment_menu = menu.full_title
      @reservation.treatment_time_menu = menu.treatment_time
      @reservation.topping_menu = topping_number_menu.title if topping_number_menu.present?
      @reservation.charge_menu = menu.charge
      @reservation.add_nail_count_menu = add_nail_number_menu.add_nail_count if add_nail_number_menu.present?
      
      if topping_number_menu.present? && add_nail_number_menu.present?                           #トッピングあり && 巻き爪補正あり
        @reservation.full_charge_menu = menu.charge + topping_number_menu.charge + add_nail_number_menu.charge 
      elsif add_nail_number_menu.present? && !topping_number_menu.present?                      #トッピングなし && 巻き爪補正あり
        @reservation.full_charge_menu = menu.charge + add_nail_number_menu.charge
      elsif topping_number_menu.present? && !add_nail_number_menu.present?                      #トッピングあり、巻き爪補正なし
        @reservation.full_charge_menu = menu.charge + topping_number_menu.charge
      else                                                                                       #トッピングなし、巻き爪補正なし
        @reservation.full_charge_menu = menu.charge
      end
      @reservation.apply!(menu_time)
    end

    if @reservation.save(context: :registration) #ゲストが新規予約する時だけ予約時間の範囲を限定する。
      user = User.find(@reservation.guest_id)
      #申込したゲストへのメール
      # UserMailer.request_reservation(user, @reservation).deliver_now
      #スタッフへのメール
      # UserMailer.request_reservation_staff(user, @reservation).deliver_now
      flash[:warning] = "お客様の仮予約が完了しました。承認されるまでお待ちください。"
      redirect_to reservations_url
    end
  end

  # スタッフが予約を確定する画面
  def edit
  end

  # スタッフが予約を確定する処理
  def update
    title_for_staff_comment = "予約確定 #{@reservation.guest.name}様 #{@reservation.treatment_menu}  #{@reservation.staff.name}"
    @reservation.update(status: :on_reserve, title_for_guest: "予約確定", title_for_staff: title_for_staff_comment)
    user = User.find(@reservation.guest_id)
    #ゲストへの予約確定メール
    # UserMailer.reservation_confirm(user, @reservation).deliver_now
    flash[:success] = "予約確定をしました。"
    redirect_to confirm_reservation_reservations_url
  end

  # スタッフが予約を編集する画面
  def edit_reserve
    @courses = @menus.where.not(category_number: "4").where.not(category_title_number: "4").where.not(category_number: "3")
    @add_nail_menus = @menus.where(category_number: "4").where(category_title_number: "4") # 巻き爪補正メニュー
    @topping_menus = @menus.where(category_number: "3") # トッピングメニュー
  end

  # スタッフが予約を編集する処理
  def update_reserve
    if @reservation.update(reservation_params)
      menu = Menu.find(reservation_params[:course]) unless reservation_params[:course].blank?
      add_nail_number_menu = Menu.find(reservation_params[:add_nail_number_menu]) unless reservation_params[:add_nail_number_menu].blank?
      topping_number_menu = Menu.find(reservation_params[:topping_number_menu]) unless reservation_params[:topping_number_menu].blank?
      if menu.present?
        if topping_number_menu.present?
          menu_time = 60 * (menu.treatment_time + topping_number_menu.treatment_time + 10) # end_time登録の為に使用。インターバルタイムを10分追加した時間でend_timeを登録
        else
          menu_time = 60 * (menu.treatment_time + 10) # end_time登録の為に使用。インターバルタイムを10分追加した時間でend_timeを登録
        end
        @reservation.treatment_menu = menu.full_title
        @reservation.treatment_time_menu = menu.treatment_time
        @reservation.topping_menu = topping_number_menu.title if topping_number_menu.present?
        @reservation.charge_menu = menu.charge
        @reservation.add_nail_count_menu = add_nail_number_menu.add_nail_count if add_nail_number_menu.present?
        
        if topping_number_menu.present? && add_nail_number_menu.present?                           #トッピングあり && 巻き爪補正あり
          @reservation.full_charge_menu = menu.charge + topping_number_menu.charge + add_nail_number_menu.charge
        elsif add_nail_number_menu.present? && !topping_number_menu.present?                      #トッピングなし && 巻き爪補正あり
          @reservation.full_charge_menu = menu.charge + add_nail_number_menu.charge
        elsif topping_number_menu.present? && !add_nail_number_menu.present?                      #トッピングあり、巻き爪補正なし
          @reservation.full_charge_menu = menu.charge + topping_number_menu.charge
        else                                                                                       #トッピングなし、巻き爪補正なし
          @reservation.full_charge_menu = menu.charge
        end
        @reservation.apply_update!(menu_time)
      end
      if reservation_params[:cancel_flag] == "1"
        @reservation.update(status: :completed)
      else
        if reservation_params[:status] == "on_request"
          @reservation.update(
            title_for_guest: "仮予約",
            title_for_staff: "仮予約"
          )
        elsif reservation_params[:status] == "on_reserve"
          title_for_staff_comment = "予約確定 #{@reservation.guest.name}様  #{@reservation.treatment_menu}  #{@reservation.staff.name}"
          @reservation.update(
            title_for_guest: "予約確定",
            title_for_staff: title_for_staff_comment
          )
        end
      end
        flash[:success] = "予約を編集しました。"
        redirect_to reservation_management_reservations_url
    else
      flash[:danger] = "編集に失敗しました。"
      redirect_to edit_reserve_reservation_url(@reservation)
    end
  end

  def cancel_reserve
    # cancel_flagを1にする事で論理削除実施 & ステータスを3(completed施術完了)に切り替え
    @reservation.update(cancel_flag: 1, status: :completed)
    flash[:warning] = "予約をキャンセルしました。"
    redirect_to reservation_management_reservations_url
  end

  def destroy
    # cancel_flagを1にする事で論理削除実施 & ステータスを3(completed施術完了)に切り替え
    @reservation.destroy
    flash[:danger] = "予約を削除しました。"
    redirect_to reservation_management_reservations_url
  end

  private

    def reservation_params
      params.require(:reservation).permit(:start_time,
                                          :end_time,
                                          :course,
                                          :comment,
                                          :status,
                                          :cancel_flag,
                                          :reservation_time,
                                          :staff_id,
                                          :guest_id,
                                          :store_id,
                                          :add_nail_number_menu,
                                          :topping_number_menu
      )
    end

    def set_reservations
      @reservations = Reservation.includes(:guest)
    end

    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    def set_menus
      @menus = Menu.where(reserve_flag: 0).order(course_number: :asc)
    end

    def set_users
      @users = User.all
    end

    def reservation_completed
      now = Time.current
      # .where('end_time > ?', now.yesterday.end_of_day)を入れる事で無駄なSQL（一日以上前のデータ）を流さないようにする
      reservations = Reservation.where('end_time > ?', now.yesterday.end_of_day).where('end_time < ?', now)
      reservations.each do |reservation|
        # :day_after_todayのバリデーションに引っかかるので、バリデーションの方を削除
        reservation.update(status: :completed) #ステータスを3(completed施術完了)に切り替え
      end
    end

    def set_q
      @q = Reservation.includes(:guest).ransack(params[:q])
    end

    def set_new
      @reservation = Reservation.new
    end

    def set_staffs
      @staffs = Staff.all
    end

end
