#made by Nguyen Gia Bao Pham 
require 'gosu'

module Z0rder 
  BACKGROUND, PLAYER, ALIENSHIP, BULLET, BLOOD, EXPLOSION, BOSS, HEART, COIN, BOSSLASER, UI = *0..10 
end




class FramInvaders < Gosu::Window 
    MAX_ENEMIES = 200 
     WIDTH = 1000 
    HEIGHT = 800 
    def initialize 
        super(WIDTH, HEIGHT) #create window game 
        self.caption = "Fram Invader"
        #setting up the srtat screen of the game 
        @background_image = Gosu::Image.new('Images/start_screen.jpeg')
        @background_game = Gosu::Image.new('Images/space.jpeg')
        @image_theme = Gosu::Image.load_tiles('Images/themestart.jpeg', 100, 100)
        @image_theme1 = Gosu::Image.load_tiles('Images/alienship.png', 32, 32)
        @image_index = 0
        @index_index1 = 0
        @screne = :start 
        @font = Gosu::Font.new(25)
        @start_music = Gosu::Song.new('Sounds/maintheme.mp3')
        @start_music.play(true)
        @enemy_rate = 0.01 
        @choice = Gosu::Color::BLACK
        @choice1 = Gosu::Color::BLACK 
        @choice2 = Gosu::Color::BLACK 
        
    end


    def initialize_game 
      #setting up the image screen 
      
      @player = Player.new(500,400)
      @enemy_appaered = 0 
      @alienships_detroyed = 0
      @blood = []
      @coin = []
      @boss = []
      @bosslaser = []
      @alienships = []
      @bullets = []
      @explosions = []
      @heart = []
      @screne = :ingame 
      @game_music = Gosu::Song.new('Sounds/ingame.mp3')
      @game_music.play(true)
      @alienships_sound = Gosu::Sample.new('Sounds/alienship.mp3')
      @shooting_sound = Gosu::Sample.new('Sounds/shoot.mp3')
      @hit_sound = Gosu::Sample.new('Sound/bum.mp3')
      @coin_absorp = Gosu::Sample.new('Sounds/coins.mp3')
    end

    def initialize_end(ending)
      #setting up the end srceen 
        case ending 
           when :survied 
            @message = "You survied it! Your score is #{@player.score}.!!!"

           when :dead
            @message = "You DIED!!!"
            @message2 = "Before you died, "
            @message3 = "Your score is #{@player.score}." 

        end
      @bottom_message = "Press P to play again, or Q to quit."
      @message_font = Gosu::Font.new(30)
      @screne = :end 
      @end_music = Gosu::Song.new('Sounds/endingtheme.mp3')
      @ending_music.play(true)
    end
    class Player 
  
         attr_accessor :x, :y, :center, :image, :lives, :score 

        def initialize(x,y)
            @x = x
            @y = y 
            @image = Gosu::Image.load_tiles('Imgaes/ship.gif', 60, 152)
            @center = 20 
            @live = 5 
            @score = 0  

        end
    end


    def move_left(player)
        player.x -=7
        if player.x >= WIDTH - 2 * player.center 
           player.x = WIDTH - 2 * player.center 
        end
    end
    def move_up(player)
        player.y -=7
        if player.y <= 0 
           player.y = 0 
        end
    end
    def move_down(player)
        player.y +=7
        if player.y >= 800 
           player.y = 800 
        end
    end
    def draw_player(player)
        current_img = player.image[Gosu.milliseconds / 20 % 
            player.image.length]
                current_img.draw(player.x, player.y, ZOrder::PLAYER)
    end


        class Alienship
            
            attr_accessor :x, :y, :center, :image, :vel_x, :vel_y

            def initialize()
              @x = x 
              @y = y 
              @vel_x = rand(-4..4)
              @vel_y = rand(3..5)
              @center = 22
              @image = Gosu::Image.load_tiles('Images/alienship.png', 40, 50)
            end
        end
    def move_alienship(alienship)
        alienship.y += alienship.vel_y 
        alienship.x += alienship.vel_x
        alienship.vel_x *= -1 if (alienship.x + alienship.center > 1000)  || alienship.x < 0 
    end
    def draw_alienship(alienship)
        current_img = alienship.image[Gosu.milliseconds / 120 %
            alienship.image.length]
                current_img.draw(alienship.x, alienship.y, ZOrder::ALIENSHIP)
    end

    class Bullet 
        
        attr_accessor :x, :y, :image, :image, :center, :vel_y 

        def initialize(x,y)
          @x = x
          @y = y  
          @vel_y = 10 
          @image = Gosu::Image.load_tiles('Images/bullet.png', 20, 20)
          @center = 3 
        end
    end
    def shoot(bullet)
        bullet.y -= bullet.vel_y 
    end
    def draw_bullet(bullet)
        current_img = bullet.image[Gosu.milliseconds / 20 %
            bullet.image.length]
                current_img.draw(bullet.x, bullet.y, Z0rder::BULLET)
    end

    class Explosion 
          
        attr_accessor :x, :y, :center, :image, :finished, :index

        def initialize(x,y)
          @x = x
          @y = y 
          @center = 30 
          @image = Gosu::Image.load_tiles('Images/explosions.png', 60, 60)
          @index = 0 
          @finished = false
        end
    end
    def draw_explosion(explosion)
        current_img = explosion.image[Gosu.milliseconds / 50 %
            explosion.image.length]
        current_img.draw(explosion.x, explosion.y, Z0rder::EXPLOSION)
        if current_img == explosions.image[explosion.imgae.length - 1]
            explosion.finished = true 
        end
    end
    #remove explosion tiles 
    def remove_explosions 
      @explosions.reject! do |explosion|
        if explosion.finished 
          true
        else 
          false 
        end
      end
    end

    class Blood 
         
        attr_accessor :x, :y, :center, :image, :sound, :finished, :index 

        def initialize(x,y)
          @x = x 
          @y = y 
          @center = 30 
          @image = Gosu::Image.load_tiles('Images/blood.png', 50, 50)
          @index = 0 
          @finished = false 
        end
    end
    def draw_blood(blood) 
        current_img = blood.image[Gosu.milliseconds / 50 % 
    blood.image.length]
        current_img.draw(blood.x, blood.y, Z0rder::BLOOD)
        if current_img == blood.image[blood.image.length - 1]
           blood.finished = true 
        end
    end
    #remove bloods tiles 
    def reomve_bloods 
        @bloods.reject! do |blood|
          if blood.finished 
            true 
          else 
            false
          end
        end
    end

    class Heart 
      
        attr_accessor :x, :y, :center, :image, :vel_y 

        def initialize()
            @x = rand(WIDTH)
            @y = 0 
            @image = Gosu::Image.new('Images/heart.png')
            @center = 20 
            @vel_y = 5 
        end
    end
    def move_heart(heart)
        heart.y += heart.vel_y 
    end
    def draw_heart(heart)
        heart.image.draw(heart.x, heart.y, Z0rder::HEART)
    end

    class Coin 
      
        attr_accessor :x, :y, :center, :image, :vel_y

        def initialize(x,y)
            @x = x 
            @y = y 
            @image = Gosu::Image.load_tiles('Images/diamond.png', 40, 36)
            @center = 20 
            @vel_y = 5 
        end
    end
        def move_coin(coin)
            coin.x += coin.vel_y   
        end 
        def draw_coin(coin)
            current_img = coin.image[Gosu.milliseconds / 120 %
                coin.image.length]
                    current_img.draw(coin.x, coin.y, Z0rder::COIN)
        end


    class Boss 
        
        attr_accessor :x, :y, :center, :vel_y, :hp, :image
        
        def initialize
          @x = 0 
          @y = rand(50..300)
          @image = Gosu::Image.load_tiles('Images/alien.jpeg', 48, 42)
          @vel_x = 2
          @center = 24 
          @hp = 5 
        end
    end
    def move_boss(boss)
        boss.x += boss.vel_x 
    end
    def move_boss(boss)
        current_img = boss.image[Gosu.milliseconds / 120 %
            boss.image,length]
                current_img.draw(boss.x, boss.y, Z0rder::BOSS)
    end

    class Bosslaser
           
        attr_accessor :x, :y, :center, :image, :vel_y 

        def initialize(x,y)
            @x = x 
            @y = y 
            @vel_y = 5 
            @image = Gosu::Image.load_tiles('Images/bosslaser')
            @center = 3
        end
    end 
    def boss_shoot(bosslaser) 
        bosslaser.y += bosslaser.vel_y 
    end
    def draw_bosslaser(bosslaser)
        current_img = bosslaser.image[Gosu.milliseconds / 20 %
            bosslaser.image.length]
                 current_img.draaw(bosslaser.x, bosslaer.y, Z0rder::BOSSLASER)
    end


    def update_start 
    #create button for player to select difficulties 
    if mouse_over_button(mouse_x, mouse_y,300,100,450,150)
       @choice = Gosu::Color::BLUE 
    else 
        @choice = Gosu::Color::BLACK 
    end
    if mouse_over_button(mouse_x, mouse_y,300,200,450,250)
        @choice1 = Gosu::Color::BLUE
    else 
        @choice1 = Gosu::Color::BLACK 
    end 
    if mouse_over_button(mouse_x, mouse_y,300,300,450,350)
        @choice2 = Gosu::Color::BLUE
    else 
        @choice2 = Gosu::Color::BLACK 
    end
    end 

    def update_game 
    #moving function of player 
        move_left @player if Gosu.button_down? Gosu::KB_LEFT 
        move_right @player if Gosu.button_down? Gosu::KB_RIGHT 
        move_up @player if Gosu.button_down? Gosu::KB_UP 
        move_down @player if Gosu.button_down? Gosu::KB_DOWN 
        if rand < enemy_rate 
            @alienships.push (Alienship.new())
            @enemy_appaered += 1
        end
        #moving function for each alien spaceship 
        @alienships.each do |alienship|
            move_alienship(alienship)
        #moving function for each bullet
        end
        @bullets.each do |bullet|
           shoot(bullet)
        end
        #generate heart 
        if rand(200) == 1
           @heart.push (Heart.new())
        end
        #moving function for each heart healing potion 
        @hearts.each do |heart|
            move_heart(heart)
        end
        #moving function each coin 
        @coin.each do |coin|
          move_coin(coin)
        end
        #randomly generate boss 
        if rand(200) == 1 
           @boss.push(Boss.new())
        end
        #moving function for each boss 
        @boss.each do |boss|
            move_boss(boss)
            if rand(30) ==1 #generate bullet which are shot by boss 
               @bosslaser.push(Bosslaser.new(boss.x, boss.y))
            end
        end
        @bosslaser.each do |bosslaser| #moving function for each boss bullet 
            boss_shoot(bosslaser)
        end 
        
        #delete boss if player shoot it down 
        @boss.each do |boss|
            @bullet.each do |bullet|
                distance = Gosu.distance(boss.x boss.y, bullet.x, bullet.y)
                if distance < boss.center + bullet.center 
                    boss.hp -= 1

                    @explosion.push Explosion.new(boss.x, boss.y)
                    @bullets.delete bullet 
                    @hit_sound.play 

                end
                if boss.hp == 0 
                   @boss.delete boss 
                end
            end
        end
        #decrease health if boss hit player 
        @boss.each do |boss|
          
            distance = Gosu.distance(boss.x, boss.y, @player.x, @player.y)
            if distance < boss.center + @player.center 
               @boss.delete boss 
               @explosions.push Explosion.new(boss.x, boss.y)

               @player.lives -=5
               @hit_sound.play
            end

        end

        #delete alien spaceship if player shoot down it 
        
        @alienships.each do |alienship|
            @bullet.each do |bullet|
                distance = Gosu.distance(alienship.x, alienship.y, bullet.x, bullet.y)
                if distance < alienship.center + bullet.center 
                    @alienships.delete alienship 
                    @explosions.push Explosion.new(alienship.x, alienship.y)
                    @coins.push Coin.new(alienship.x, alienship.y) 
                    @bullet.delete bullet 
                    @alienship_sound.play  
                end
            end
        end

        #delete alien spaceship and decrease player's health if the alien spaceship hit the player 
        @alienships.each do |alienship|
          
            distance = Gosu.distance(alienship.x, alienship.y, player.x, player.y)
            if distance < alienship.center + @player.center 
              @alienships.delete alienship 
              @explosions.push Explosion.new(alienship.x, alienship.y,)

              @player.lives -= 1 
              @hit_sound.play 
              @player.score += 20 
            end
        end

        #decrease player's health if boss shoots the player successfully
        @bosslaser.each do |bosslaser|
            
            distance = Gosu.distance(bosslaser.x, bosslaser.y, @player.x, @player.y)
            if distance < bosslaser.center + @player.center
                @bosslaser.delete bosslaser
                @explosions.push Explosion.new(bosslaser.x, bosslaser.y)
                @player.lives -=1
                @hit_sound.play
            end
        end
        #increase health if player hit the heart
        @hearts.each do |heart|
            
            distance = Gosu.distance(heart.x, heart.y, @player.x, @player.y)
            if distance < heart.center + @player.center
                @hearts.delete heart
                @bloods.push Blood.new(heart.x, heart.y)
                
                @player.lives +=1
                @coin_absorp.play
            end

            
            @coins.each do |coin|   #increase score if player hit the coin
            
                distance = Gosu.distance(coin.x, coin.y, @player.x, @player.y)
                if distance < coin.center + @player.center
                    @coins.delete coin
                    @bloods.push Blood.new(heart.x, heart.y)
                    
                    @player.score +=100
                    @coin_absorp.play
                end
            end
        end
          self.remove_bloods 
          self.reomve_explosions 
          if @player.lives <= 0 
            initialize_end(:dead)
          end
            initialize_end(:survived) if @enemy_appaered > MAX_ENEMIES 
    end 

    def button_down(id)
        case @srcene 
        when :start 
            button_down_start(id)
        when :ingame 
            button_down_game(id)
        when :end 
            button_down_end(id)
        end
    end

    def button_down_start(id)
        if id == Gosu::MsLeft #enemy rate in easy mode 
           if mouse_over_button(mouse_x, mouse_y,300,100,450,150)
              @enemy_rate = 0.01
           end
        end
        if id == Gosu::MsLeft #enemy rate in hard mode 
           if mouse_over_button(mouse_x, mouse_y,300,200,450,250)
             @enemy_rate = 0.03
           end
        end
        if id == Gosu::MsLeft #enemy rate in insane mode 
          if mouse_over_button(mouse_x, mouse_y,300,300,450,350)
            @enemy_rate = 0.1 
            @player.lives = 15 
          end
        end
        initialize_game 

    end

    def button_down_game 
       if id == Gosu::KbSpace 
         @bullets.push Bullet.new(@player.x + @player.center, @player.y)
         @shooting_sound.play(1)
       end
    end

    def button_down_end(id)
        if id == Gosu::KbP 
           initialize
        elsif id == Gosu::KbQ 
            close 
        end
    end

    def need_cursor? 
        true 
    end

    def mouse_over_button(mouse_x, mouse_y, leftX, topY, rightX, botY)
       if (mouse_x > leftX) and (mouse_x < rightX) and (mouse_y > topY) and (mouse_y < botY)
          true 
       else 
          false 
       end
    end



    def draw_start 
        @background_image.draw(0,0,0)
        if @image_index < @imagetheme.count 
           @image_theme[@image_index].draw(100, 100, 2)

           @image_index += 1 
           if @image_index == @image_theme.count 
              @image_index = 0 
           end
        end
        if @image_index1 < @image_theme1.count
            @image_theme1[@image_index1].draw(650, 115 , 2)  #draw button
            sleep(0.05)
            @image_theme1[@image_index1].draw(650, 215 , 2)
            sleep(0.05)
            @image_theme1[@image_index1].draw(650, 315 , 2)
            sleep(0.05)
            @image_index1 +=1 
            if @image_index1 == @image_theme1.count
                @image_index1 = 0 
            end 
        end 
        @font.draw("TRY TO SURVIVE THE INVASION OF AILIEN SPACESHIPS!!!!!",200,500, 0)
        @font.draw("EASY MODE",500,125, 0)
        @font.draw("HARD MODE",500,225, 0)
        @font.draw("INSANE MODE",500,325, 0)
        Gosu.draw_rect(290,90,170,70, @choice)
        Gosu.draw_rect(290,190,170,70, @choice1)
        Gosu.draw_rect(290,290,170,70, @choice2)
        Gosu.draw_rect(300 ,100, 150, 50, Gosu::Color::GREEN)
        Gosu.draw_rect(300 ,200, 150, 50, Gosu::Color::YELLOW)
        Gosu.draw_rect(300 ,300, 150, 50, Gosu::Color::RED)


    end

    def draw_game 
        @background_game.draw(0, 0, Z0rder::BACKGROUND)
        draw_player(@player)
        @alienships.each do |alienship|
        draw_alienship(alienship)
        end
        @bullets.each do |bullet| 
            draw_bullet(bullet) 
        end
        @explosions.each do |explosion|
            draw_explosion(explosion)
        end
        @hearts.each do |heart|
            draw_heart(heart)
        end
        @bloods.each do |blood|
            draw_blood(blood)
        end
        @coins.each do |coin|
            draw_coin(coin)
        end
        @boss.each do |boss|
            draw_boss(boss)
        end
        @bosslaser.each do |bosslaser|
            draw_bosslaser(bosslaser)
        end
        @font.draw("Enemies left: #{MAX_ENEMIES - @enemies_appeared}", 600,0,ZOrder::UI)
        @font.draw("Score: #{@player.score}", 600,50,ZOrder::UI)
        @font.draw("Lives: #{@player.lives}", 800,50,ZOrder::UI)
        #@font.draw("Ammo: #{@reload}", 800,0,0)
    end

    def draw_end        
        @message_font.draw(@message,40,240,ZOrder::UI,1,1,Gosu::Color::RED)
        @message_font.draw(@message2,40,275,ZOrder::UI,1,1,Gosu::Color::RED)
        @message_font.draw(@bottom_message,180,540,ZOrder::UI,1,1,Gosu::Color::RED)
    end

    def update
        if @scene == :start 
                update_start
        end
        if @scene == :ingame
                update_game
        end
    end

    

    def draw
        case @scene
            when :start
                draw_start
            when :ingame
                draw_game
            when :end
                draw_end
        end
    end
end

FramInvaders.new.show 