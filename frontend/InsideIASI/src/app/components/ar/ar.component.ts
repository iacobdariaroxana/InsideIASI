import { Component, OnInit } from '@angular/core';
import { CustomEvent1 } from 'src/app/model';

@Component({
  selector: 'app-ar',
  templateUrl: './ar.component.html',
  styleUrls: ['./ar.component.css'],
})
export class ARComponent implements OnInit {
  ngOnInit(): void {
    let testEntityAdded = false;

    const el = document.querySelector('[gps-new-camera]');
    console.log(el);
    el?.addEventListener('gps-camera-update-position', (e: Event) => {
      const custom = e as CustomEvent1;
      console.log(e);
      alert(
        `Got first GPS position: lon ${custom.detail.position.longitude} lat ${custom.detail.position.latitude}`
      );
      const entity = document.createElement('a-box');
      entity.setAttribute('material', JSON.stringify({ color: 'red' }));
      entity.setAttribute('gps-new-entity-place', JSON.stringify({
          latitude: custom.detail.position.latitude + 0.001,
          longitude: custom.detail.position.longitude
      }));
      document.querySelector("a-scene")?.appendChild(entity);
    });
  }
}
