import { CUSTOM_ELEMENTS_SCHEMA, NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { AppComponent } from './app.component';
import { AppRoutingModule } from './app-routing.module';
import { IonicModule } from '@ionic/angular';
import { GoogleMapsModule } from '@angular/google-maps'
import { StartComponent } from './components/start/start.component';
import { MenuComponent } from './components/menu/menu.component';
import { MapComponent } from './components/map/map.component';
import { HttpClient, HttpClientModule } from '@angular/common/http';
import { GoogleMapsComponent } from './components/google-maps/google-maps.component';
import { ARComponent } from './components/ar/ar.component';
import { TranslateLoader, TranslateModule } from '@ngx-translate/core';
import { TranslateHttpLoader } from '@ngx-translate/http-loader';
import { HourWeatherComponent } from './components/hour-weather/hour-weather.component';
import { WeatherDialogComponent } from './components/weather-dialog/weather-dialog.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import {MatDialogModule} from '@angular/material/dialog';


@NgModule({
  declarations: [
    AppComponent,
    StartComponent,
    MenuComponent,
    MapComponent,
    GoogleMapsComponent,
    ARComponent,
    HourWeatherComponent,
    WeatherDialogComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    IonicModule.forRoot(),
    GoogleMapsModule,
    HttpClientModule,
    TranslateModule.forRoot({
      loader: {
        provide: TranslateLoader,
        useFactory: httpTranslateLoader,
        deps: [HttpClient]
      }
    }),
    BrowserAnimationsModule,
    MatDialogModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
export function httpTranslateLoader(http: HttpClient ){
  return new TranslateHttpLoader(http);
}