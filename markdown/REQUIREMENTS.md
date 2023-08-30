# Requirements

1. :white_check_mark: The app should allow users to search for songs, albums or artists by typing in search criteria.
2. :white_check_mark: The app should display the search results in a list showing the song name, artist, and album art.

3. :white_check_mark: The app should support paging the search results by providing the ability to load more records. Each page limits 20 records.

4. :white_check_mark: The app should allow users to filter the search results by country or media type.

5. :white_check_mark: The app should provide the ability to bookmark songs by adding them to a "favorites" list, which can be accessed later.

6. :white_check_mark: The app should be available in English, Traditional Chinese (Hong Kong), and Simplified Chinese (China) languages.

7. :white_check_mark: The app should have a clean and intuitive design that is easy to use.

8. :white_check_mark: The app should support iOS 12+ / Android 6.0+.

# Solutions

<details>
<summary>Pagination</summary>

1. Set a limit to get the track from API.

2. Create an array to store new tracks which get from API.

3. When user scroll to the last cell from the track table, it will call the API again and append new tracks to store in the array.

4. If the new API return the array is below the limit, it **WILL NOT** call the API when user scroll to the last cell. It prevents to call the API continuously.

</details>

<details>
<summary>Localizable</summary>

1. Go to the **project page** and **Info** tab.

2. Add the language which you needed in **Localization**. As the project requirement, I added _English_, _Chinese (Hong Kong)_ and _Chinese, Simplified (China)_.

3. Create a string file called `Localizable.string`.

4. Go to the Inspector which in XCode's right hand side. Tick all the language which you needed. The string file will create the sub-file for each language.

5. Add below code to apply the localizable for each text.

   ```swift
   NSLocalizedString(key, comment: "")
   ```

6. Done :beers:.

</details>

<details>
<summary>Play music</summary>

1. Implement `AVFoundation` to play the music track.

   ```swift
   import AVFoundation
   ```

2. Add `PeriodicTimeObserver` to observe music's duration time and current time.

   ```swift
   self.player.addPeriodicTimeObserver()
   ```

3. Insert the track `AVPlayerItem` in to the player.

   ```swift
   self.player.insert(AVPlayerItem(url: URL(string: previewUrl)!), after: nil)
   ```

4. Play the music.

   ```swift
   self.player.play()
   ```

   </details>

<details>
<summary>Use model presentation</summary>

1. Apply model presentation method to show the player.

2. In modal presentation, there cannot tigger the `viewWillAppear` and `viewDidAppear` function by callback. Therefore, I added observer to observe the dismiss action.

3. When user clicked **Favourite** button in the player, the track will add into **Favourite**. User can browse the track which can be accessed later on the top of home page.
</details>
