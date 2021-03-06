package ;
import flash.display.*;
import flash.geom.*;
import flash.events.*;
import flash.net.*;
import org.si.sion.SiONVoice;

class Drumkitclass {
    public function new():Void {
        size = 0;
    }
    
    public function updatefilter(cutoff:Int, resonance:Int):Void {
        var i:Int = 0;
        while( i < size){
            if(voicelist[i].channelParam.cutoff != cutoff || voicelist[i].channelParam.resonance != resonance){
                voicelist[i].setFilterEnvelop(0, cutoff, resonance);
            }
            i++;
        }
    }
    
    public function updatevolume(volume:Int):Void {
        var i:Int = 0;
        while( i < size){
            if(voicelist[i].velocity!=volume){
                voicelist[i].updateVolumes = true;
                voicelist[i].velocity = volume;
            }
            i++;
        }
    }
    
    public var voicelist: Array<SiONVoice> = new Array<SiONVoice>();
    public var voicename: Array<String> = new Array<String>();
    public var voicenote: Array<Int> = new Array<Int>();
    public var midivoice:Array<Int> = new Array<Int>();
    public var kitname:String;
    public var size:Int;
}

