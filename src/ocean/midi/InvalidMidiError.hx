
package ocean.midi;

 class InvalidMidiError implements Dynamic extends flash.errors.Error {
	
	
	public function new(message:String="",id:Int=0):Void{
		super(message,id);
	}
}


