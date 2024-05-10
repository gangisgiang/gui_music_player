require 'rubygems'
require 'gosu'

TOP_COLOR = Gosu::Color.new(0xFF1EB1FA)
BOTTOM_COLOR = Gosu::Color.new(0x97C0EF)
ARTWORK_WIDTH = 200

module ZOrder
  BACKGROUND, MIDDLE, TOP = *0..2
end

# Put your record definitions here

class Album
    attr_accessor :artist, :title, :tracks, :artwork

    def initialize(artist, title, tracks, artwork)
		@artist = artist
        @title = title
        @tracks = tracks
		@artwork = artwork
    end
end

class Track
    attr_accessor :name, :location

    def initialize(n, l)
        @name = n
        @location = l
    end
end

def read_music_track(a_file)
    track_name = a_file.gets.chomp
    track_location = a_file.gets.chomp
    return Track.new(track_name, track_location)
end

def read_music_tracks(a_file)
    tracks = []
    index = 0

    count = a_file.gets.to_i
    while index < count
        tracks << read_music_track(a_file)
        index += 1
    end
    return tracks
end

def get_album(a_file)
    title = a_file.gets.chomp
    artist = a_file.gets.chomp
	artwork = a_file.gets.chomp
    tracks = read_music_tracks(a_file)
    return Album.new(artist, title, tracks, artwork)
end

def get_albums(file_name)
    albums = []
    a_file = File.new(file_name, 'r')
	count = a_file.gets.to_i

    index = 0
    while index < count
        albums << get_album(a_file)
        index += 1
    end

    a_file.close
    return albums
end

def read_artwork(albums)
	artworks = []
	i = 0
	while i < albums.length
		artwork = albums[i].artwork
		artworks << Gosu::Image.new(artwork)
		i+=1
	end
	return artworks
end


class MusicPlayerMain < Gosu::Window

	def initialize
	    super 806, 500
	    self.caption = "Music Player"

		# Reads in an array of albums from a file and then prints all the albums in the
		# array to the terminal
		@albums = get_albums('albums.txt')
		@artworks = read_artwork(@albums)

        @font = Gosu::Font.new(15)
		@track_font = Gosu::Font.new(25)

		@chosed_song = 0
		@song = nil
		@tracks = {}
		
		@another_song = true

		@text_to_display = []
		@text_to_display1 = []
		@text_to_display2 = []
		@text_to_display3 = []

		@album_title_colors = [Gosu::Color::WHITE] * @albums.length

		populate_tracks
	end

	def draw_albums(albums)
		# Draw album artworks
		@artworks.each_with_index do |artwork, index|
		  x = index.even? ? 22 : 267
		  y = index < 2 ? 26 : 270
		  artwork.draw(x, y, ZOrder::TOP)
		end
	  
		# Draw album titles
		@font.draw_text("CHARLIE", 100, 235, ZOrder::TOP, 1.0, 1.0, @album_title_colors[0])
		@font.draw_text("Freudian", 100, 475, ZOrder::TOP, 1.0, 1.0, @album_title_colors[1])
		@font.draw_text("OP.01", 346, 235, ZOrder::TOP, 1.0, 1.0, @album_title_colors[2])
		@font.draw_text("sinh", 355, 475, ZOrder::TOP, 1.0, 1.0, @album_title_colors[3])

	end

	def populate_tracks
		@albums.each_with_index do |album, album_index|
			album.tracks.each_with_index do |track, track_index|
			track_y = 42 + track_index * 45
			@tracks[track.name] = { x: 520, y: track_y, zorder: ZOrder::TOP, color: Gosu::Color::WHITE }
			end
		end
	end



  # Takes a track index and an Album and plays the Track from the Album

  def playTrack(track, album)
  	 # complete the missing code
  			@song = Gosu::Song.new(album.tracks[track].location)
  			@song.play(false)
    # Uncomment the following and indent correctly:
  	#	end
  	# end
  end

# Draw a coloured background using TOP_COLOR and BOTTOM_COLOR

	def draw_background
		Gosu.draw_rect(0, 0, 801, 500, BOTTOM_COLOR, ZOrder::BACKGROUND, mode=:default)
	end

# Not used? Everything depends on mouse actions.

	def update
	end

 # Draws the album images and the track list for the selected album

	def draw
		# Complete the missing code
		draw_background
		draw_albums(@albums)

		# if @t1
		# 	@track_font.draw_text(@t1, 520, 42, ZOrder::TOP)
		# end
		# if @t2
		# 	@track_font.draw_text(@t2, 520, 79, ZOrder::TOP)
		# end
		@text_to_display.each do |track|
			@track_font.draw_text(track[:text], track[:x], track[:y], track[:zorder])
		end
		@text_to_display1.each do |track|
			@track_font.draw_text(track[:text], track[:x], track[:y], track[:zorder])
		end
		@text_to_display2.each do |track|
			@track_font.draw_text(track[:text], track[:x], track[:y], track[:zorder])
		end
		@text_to_display3.each do |track|
			@track_font.draw_text(track[:text], track[:x], track[:y], track[:zorder])
		end

	end

 	def needs_cursor?; true; end

	# If the button area (rectangle) has been clicked on change the background color
	# also store the mouse_x and mouse_y attributes that we 'inherit' from Gosu
	# you will learn about inheritance in the OOP unit - for now just accept that
	# these are available and filled with the latest x and y locations of the mouse click.

	def button_down(id)
		case id
	    when Gosu::MsLeft

			@album_title_colors.map! { Gosu::Color::WHITE }

	    	# What should happen here?
			if mouse_x.between?(22, 222) && mouse_y.between?(26, 235)
        # Your code for handling mouse click goes here
				@album_title_colors[0] = Gosu::Color::AQUA
      			@text_to_display = []

      # Iterate over all the tracks of the selected album
      			@albums[0].tracks.each_with_index do |track, i|
        # Store each track's name and position for drawing
        		@text_to_display << { text: track.name, x: 520, y: 42 + i * 45, zorder: ZOrder::TOP }
      		end
			  @text_to_display1 = []
			  @text_to_display2 = []
			  @text_to_display3 = []
			elsif mouse_x.between?(22, 222) && mouse_y.between?(228, 428)
		# Your code for handling mouse click goes here
				@album_title_colors[1] = Gosu::Color::AQUA
				@text_to_display1 = []

		# Iterate over all the tracks of the selected album
				@albums[1].tracks.each_with_index do |track, i|
		# Store each track's name and position for drawing
				@text_to_display1 << { text: track.name, x: 520, y: 42 + i * 45, zorder: ZOrder::TOP }
			end
			@text_to_display = []
			@text_to_display2 = []
			@text_to_display3 = []
			elsif mouse_x.between?(267, 467) && mouse_y.between?(32, 232)
		# Your code for handling mouse click goes here
				@album_title_colors[2] = Gosu::Color::AQUA
				@text_to_display2 = []

		# Iterate over all the tracks of the selected album
				@albums[2].tracks.each_with_index do |track, i|
		# Store each track's name and position for drawing
				@text_to_display2 << { text: track.name, x: 520, y: 42 + i * 45, zorder: ZOrder::TOP }
			end
			@text_to_display = []
			@text_to_display1 = []
			@text_to_display3 = []
			elsif mouse_x.between?(267, 467) && mouse_y.between?(287, 487)
		# Your code for handling mouse click goes here
				@album_title_colors[3] = Gosu::Color::AQUA
				@text_to_display3 = []

		# Iterate over all the tracks of the selected album
				@albums[3].tracks.each_with_index do |track, i|
		# Store each track's name and position for drawing
				@text_to_display3 << { text: track.name, x: 520, y: 42 + i * 45, zorder: ZOrder::TOP }
			end
			@text_to_display = []
			@text_to_display1 = []
			@text_to_display2 = []

			@tracks.each do |track_name, track_info|
				if mouse_x.between?(track_info[:x], track_info[:x] + @track_font.text_width(track_name)) &&
				   mouse_y.between?(track_info[:y], track_info[:y] + @track_font.height)

				   track_info[:color] = Gosu::Color::AQUA
        		end
			end

		end
	end	
end

end


# Show is a method that loops through update and draw

MusicPlayerMain.new.show if __FILE__ == $0
