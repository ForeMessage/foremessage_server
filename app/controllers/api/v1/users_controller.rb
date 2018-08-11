module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: [:show, :update, :destroy]

      # GET /users
      # GET /users.json
      def index
        @users = User.all

        render json: { user: @users }, status: :ok
      end

      # GET /users/1
      # GET /users/1.json
      def show
      end

      def sign_in
        nickname = params[:nickname]
        password = params[:password]

        user = User.find_by_nickname(nickname)

        # 유저 닉네임을 못 찾을 때
        render json: { message: 'invalid nickname' }, status: :bad_request and return unless user.present?

        # 비밀번호가 맞지 않을 때
        render json: { message: 'invalid password' }, status: :unauthorized and return unless user.authenticate(password)

        # SUCCESS LOGIN
        render json: { message: 'success login' }, status: :ok
      end

      # POST /users
      # POST /users.json
      def sign_up
        @user = User.new(user_params)

        respond_to do |format|
          if @user.save
            format.json { render json: { user: @user, message: '유저 생성이 되었습니다.' }, status: :created }
          else
            format.json { render json: @user.errors, status: :unprocessable_entity }
          end
        end
      end

      # PATCH/PUT /users/1
      # PATCH/PUT /users/1.json
      def update
        respond_to do |format|
          if @user.update(user_params)
            format.html { redirect_to @user, notice: 'User was successfully updated.' }
            format.json { render :show, status: :ok, location: @user }
          else
            format.html { render :edit }
            format.json { render json: @user.errors, status: :unprocessable_entity }
          end
        end
      end

      # DELETE /users/1
      # DELETE /users/1.json
      def destroy
        @user.destroy
        respond_to do |format|
          format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
          format.json { head :no_content }
        end
      end

      def check_nickname
        nickname = params[:nickname]

        respond_to do |format|
          if User.find_by_nickname(nickname)
            format.json { render json: { message: '이미 가입되어 있는 닉네임 입니다.'}, status: :conflict }
          else
            format.json { render json: { message: 'SUCCESS' }, status: :ok}
          end
        end
      end

      def verify_phone_number
        phone_number = params[:phone_number]
	
        sns = Aws::SNS::Client.new(region: 'ap-northeast-1', access_key_id: Rails.application.credentials[:access_key_id], secret_access_key: Rails.application.credentials[:secret_access_key])

        certification_number = rand(1000..9999)

        begin
          sns.publish(phone_number: "+82#{phone_number}", message: "foremessage의 인증 번호는 #{certification_number}입니다.")
          render json: { certification_number: certification_number, message: 'SUCCESS' }, status: :ok
        rescue => e
          render json: { message: e }, status: :bad_request
        end
      end

      private
      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @user = User.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def user_params
        params.permit(:nickname, :password, :password_confirmation, :phone_number, :name, :birth_day)
      end
    end
  end
end


