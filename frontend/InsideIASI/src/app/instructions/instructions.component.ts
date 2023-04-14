import { Component } from '@angular/core';
import { TranslateService } from '@ngx-translate/core';

@Component({
  selector: 'app-instructions',
  templateUrl: './instructions.component.html',
  styleUrls: ['./instructions.component.scss'],
})
export class InstructionsComponent {
  cameraInstruction!: string;
  weatherInstruction!: string;
  constructor(public _translate: TranslateService) {
    this._translate
      .get('InstructionsAR')
      .subscribe((title) => (this.cameraInstruction = title));
    this._translate
      .get('InstructionsWeather')
      .subscribe((title) => (this.weatherInstruction = title));
  }
}
