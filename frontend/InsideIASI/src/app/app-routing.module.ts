import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Routes } from '@angular/router';
import { StartComponent } from './components/start/start.component';
import { MenuComponent } from './components/menu/menu.component';
import { MapComponent } from './components/map/map.component';

const routes: Routes = [
  {path: 'home', component: StartComponent},
  {path: 'menu', component: MenuComponent},
  {path: 'map', component: MapComponent},
  {path: '', redirectTo: '/home', pathMatch: 'full'}
]

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
