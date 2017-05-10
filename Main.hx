package ;

class Main {
	var fullText = "";
	var text = "";
	var charIndex = 0;
	var line = 0;
	var charactersTyped = 0;
	var startTime = 0.0;
	public function new (){
		fullText = sys.io.File.getContent("AesopsFables.txt");
		line = Std.parseInt(sys.io.File.getContent("settings.txt"));

		Sys.println("TYPE!");
		Sys.print("\n\n");
		Sys.print("\u001b[1000D");
		
		var exit = false;
		while( !exit ){
			sys.io.File.saveContent("settings.txt",line+"");
			if (startTime == 0){
				startTime = Sys.time();
			}
			var pastMinutes = (Sys.time() - startTime)/60;
			var wpm = (charactersTyped/pastMinutes)/5;

			text = fullText.split("\n")[line];
			text = StringTools.trim(text);
			if (text == ""){
				line++;
				continue;
			}
			
			Sys.print("\033[<"+2+">A"); //Move to the left of the row.
			Sys.print("\u001b[0m");
			Sys.print("\033[<"+9999+">D"); //Move to the left of the row.
			Sys.print("\033[2K"); //Clear the current row.
			Sys.println("WPM: "+Math.floor(wpm));
			Sys.print('\n');

			Sys.print("\033[<"+9999+">D"); //Move to the left of the row.
			Sys.print("\033[2K"); //Clear the current row.
			//Draw completed text, highlighted.
			Sys.print("\u001b[7m"+text.substr(0,charIndex)+"\u001b[0m");
			//Add yet to be completed text, non-highlighted.
			Sys.print(text.substr(charIndex));
			//Next line
			Sys.print('\n');
			Sys.print("\033[2K"); //Clear the current row.
			Sys.print(fullText.split("\n")[line+1]);
			Sys.print("\033[<0>A");
			Sys.print('\033[<'+charIndex+'>C');


			 var code = Sys.getChar(false);
			var char = String.fromCharCode(code);
			
			
			if (text.split("")[charIndex] == char){

				Sys.print("\u001b[7m"+char+"\u001b[0m");
				if (charIndex == text.length-1){
					line++;
					charIndex = 0;
				}else{
					charIndex++;
					charactersTyped++;
				}
			}else{
				Sys.print("\u001b[41;1m"+ text.split("")[charIndex]+"\u001b[0m");
				
			}
			if (code == 3 || code == 27) exit = true;
		}

	}
	public static function main (){
		new Main();
	}
}