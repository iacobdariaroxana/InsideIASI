import { AfterViewInit, Component, OnInit } from '@angular/core';
import { first } from 'rxjs';
import { Location } from '@angular/common';
import { ImageService } from './services/image.service';
import { Camera, CameraResultType } from '@capacitor/camera';

@Component({
  selector: 'app-map',
  templateUrl: './map.component.html',
  styleUrls: ['./map.component.scss'],
})
export class MapComponent implements OnInit, AfterViewInit {
  constructor(
    private location: Location,
    private readonly _imageService: ImageService
  ) {}

  ngOnInit(): void {}

  ngAfterViewInit(): void {}

  async captureImage() {
    const image = await Camera.getPhoto({
      quality: 90,
      allowEditing: false,
      resultType: CameraResultType.Base64,
    });
    // console.log(image.base64String);
    this._imageService
      .getImagePlace(image.base64String!)
      .pipe(first())
      .subscribe({
        next: (response) => {
          console.log(response);
        },
        error: (err) => {
          console.log(err);
        },
      });
  }

  goBack() {
    this.location.back();
  }
}
