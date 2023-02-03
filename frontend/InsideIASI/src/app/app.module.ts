import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { AppComponent } from './app.component';
import { AppRoutingModule } from './app-routing.module';
import { IonicModule } from '@ionic/angular';
import { GoogleMapsModule } from '@angular/google-maps'
import { StartComponent } from './components/start/start.component';
import { MenuComponent } from './components/menu/menu.component';
import { MapComponent } from './components/map/map.component';
import { HttpClientModule } from '@angular/common/http';

@NgModule({
  declarations: [
    AppComponent,
    StartComponent,
    MenuComponent,
    MapComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    IonicModule.forRoot(),
    GoogleMapsModule,
    HttpClientModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
