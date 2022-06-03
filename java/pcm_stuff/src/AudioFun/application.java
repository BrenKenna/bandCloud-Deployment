package AudioFun;

import java.io.File;
import java.io.IOException;

import javax.sound.sampled.AudioFileFormat.Type;
import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.UnsupportedAudioFileException;

import be.tarsos.dsp.io.PipedAudioStream;



/**
 * Test out audio stufff
 * 
 * @author kenna
 *
 */
public class application {

	public static void main(String[] args) {

		// Check files can be read etc
		String guitarPath = "resources/site_audio_acoustic.mp3";
		File guitarFile = new File(guitarPath);
        if (guitarFile.exists()) {
            System.out.println("Guitar can be found");
        }
        else {
        	System.out.println("Nope :(");
        }

        // Read guitar
        System.out.println("\nAttempting to read audio from: " + guitarFile.toString());
        for(Type type : AudioSystem.getAudioFileTypes() ) {
        	System.out.println(type.toString());
        }
        try {
			AudioInputStream guitarAudio = AudioSystem.getAudioInputStream(guitarFile);
			System.out.println(guitarAudio.toString());
		}
        catch (Exception ex) {
			System.out.println("Cannot read audio:\n" + ex);
		}
        
        
        // Try from external project
        System.out.println("\nUsing Tarsos:\n");
        PipedAudioStream guitarPipedStream = new PipedAudioStream(guitarPath);
        System.out.println(guitarPipedStream.toString());
	}

}
