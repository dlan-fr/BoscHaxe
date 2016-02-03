package ;
import flash.display.*;
import flash.geom.*;
import flash.events.*;
import flash.net.*;

class Arrangementclass  {
    public function new():Void {
        var i:Int = 0;
        while( i < 1000){
            bar.push(new Barclass());
            i++;
        }
        i = 0;
        while( i < 100){
            copybuffer.push(new Barclass());
            i++;
        }
        copybuffersize = 0;
        
        i = 0;
        while( i < 8){
            channelon.push(true);
            i++;
        }
        clear();
    }
    
    public function copy():Void {
        var i:Int = loopstart;
        while( i < loopend){
            var j:Int = 0;
            while( j < 8){
                copybuffer[i-loopstart].channel[j] = bar[i].channel[j];
                j++;
            }
            i++;
        }
        copybuffersize = loopend-loopstart;
    }
    
    public function paste(t:Int):Void {
        var i:Int = 0;
        while( i < copybuffersize){
            insertbar(t);
            i++;
        }
        
        i = t;
        while( i < t + copybuffersize){
            var j:Int = 0;
            while( j < 8){
                bar[i].channel[j] = copybuffer[i - t].channel[j];
                j++;
            }
            i++;
        }
    }
    
    public function clear():Void {
        loopstart = 0;
        loopend = 1;
        currentbar = 0;
        
        var i:Int = 0;
        while( i < lastbar){
            var j:Int = 0;
            while( j < 8){
                bar[i].channel[j] = -1;
                j++;
            }
            i++;
        }
        
        lastbar = 1;
    }
    
    public function addpattern(a:Int, b:Int, t:Int):Void {
        bar[a].channel[b] = t;
        if (a + 1 > lastbar) lastbar = a + 1;
    }
    
    public function removepattern(a:Int, b:Int):Void {
        bar[a].channel[b] = -1;
        var lbcheck:Int = 0;
        var i:Int = 0;
        while( i <= lastbar){
            var j:Int = 0;
            while( j < 8){
                if (bar[i].channel[j] > -1) {
                    lbcheck = i;
                }
                j++;
            }
            i++;
        }
        lastbar = lbcheck + 1;
    }
    
    public function insertbar(t:Int):Void {
        var i:Int = lastbar+1;
        while( i > t){
            var j:Int = 0;
            while( j < 8){
                bar[i].channel[j] = bar[i - 1].channel[j];
                j++;
            }
            i--;
        }
        var j:Int = 0;
        while( j < 8){
            bar[t].channel[j] = -1;
            j++;
        }
        lastbar++;
    }
    
    public function deletebar(t:Int):Void {
        var i:Int = t;
        while( i < lastbar+1){
            var j:Int = 0;
            while( j < 8){
                bar[i].channel[j] = bar[i + 1].channel[j];
                j++;
            }
            i++;
        }
        lastbar--;
    }
    
    public var copybuffer: Array<Barclass> = new Array<Barclass>();
    public var copybuffersize:Int;
    
    public var bar: Array<Barclass> = new Array<Barclass>();
    public var channelon: Array<Bool> = new Array<Bool>();
    public var loopstart:Int;
    public var loopend:Int;
    public var currentbar:Int;
    
    public var lastbar:Int;
    
    public var viewstart:Int;
}

