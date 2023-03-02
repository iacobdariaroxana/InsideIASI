import { CUSTOM_ELEMENTS_SCHEMA, NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { AppComponent } from './app.component';
import { AppRoutingModule } from './app-routing.module';
import { IonicModule } from '@ionic/angular';
import { GoogleMapsModule } from '@angular/google-maps'
import { StartComponent } from './components/start/start.component';
import { MenuComponent } from './components/menu/menu.component';
import { MapComponent } from './components/map/map.component';
import { HttpClientModule } from '@angular/common/http';
import { GoogleMapsComponent } from './components/google-maps/google-maps.component';
import { ARComponent } from './components/ar/ar.component';


@NgModule({
  declarations: [
    AppComponent,
    StartComponent,
    MenuComponent,
    MapComponent,
    GoogleMapsComponent,
    ARComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    IonicModule.forRoot(),
    GoogleMapsModule,
    HttpClientModule
  ],
  providers: [],
  bootstrap: [AppComponent],
  schemas: [CUSTOM_ELEMENTS_SCHEMA]
})
export class AppModule { }
