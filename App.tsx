/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * Generated with the TypeScript template
 * https://github.com/react-native-community/react-native-template-typescript
 *
 * @format
 */

import React from 'react';
import {View, Text, StyleSheet, requireNativeComponent} from 'react-native';

import {
  Header,
  LearnMoreLinks,
  Colors,
  DebugInstructions,
  ReloadInstructions,
} from 'react-native/Libraries/NewAppScreen';

const JSIAnimatedView = requireNativeComponent('JSIAnimatedViewM');

const App = () => {
  return (
    <View style={styles.root}>
      <JSIAnimatedView style={styles.anim} />
    </View>
  );
};

type TransformTranslation = {
  x: number;
  y: number;
};

interface UIView {
  setTranslation(transform: TransformTranslation): void;
  layoutIfNeeded(): void;
}

interface PropertyAnimator {
  addAnimations(fn: () => void): void;

  addCompletion(fn: () => void): void;

  startAnimation(): void;
  pauseAnimation(): void;

  stopAnimation(withoutFinishing: boolean): void;

  continueAnimation(): void;

  setFractionComplete(factor: number): void;
}

type UIGestureRecognizerState =
  | 'UIGestureRecognizerStateBegan'
  | 'UIGestureRecognizerStateChanged'
  | 'UIGestureRecognizerStateEnded';
type Point = {x: number; y: number};
interface PanRecognizer {
  state: UIGestureRecognizerState;

  getTranslationInSuperiew(): Point;
}

(global as any).animator = {};
(global as any).view = {};

let isOpen = false;
const open = () => {
  const animator = (global as any).animator as PropertyAnimator;
  const view = (global as any).view as UIView;

  animator.addAnimations(() => {
    view.setTranslation({x: 0, y: 0});
    //view.layoutIfNeeded();
  });

  animator.addCompletion(() => {
    isOpen = true;
  });

  animator.startAnimation();
};

const close = () => {
  const animator = (global as any).animator as PropertyAnimator;
  const view = (global as any).view as UIView;
  animator.addAnimations(() => {
    view.setTranslation({x: 0, y: 500});
    // view.layoutIfNeeded();
  });

  animator.addCompletion(() => {
    isOpen = false;
  });

  animator.startAnimation();
};

(global as any).onPan = (recognizer: PanRecognizer) => {
  const animator = (global as any).animator as PropertyAnimator;
  if (recognizer.state === 'UIGestureRecognizerStateBegan') {
    if (!isOpen) {
      open();
    } else {
      close();
    }
    return;
  }
  if (recognizer.state === 'UIGestureRecognizerStateChanged') {
    const translation = recognizer.getTranslationInSuperiew();
    const factor = Math.abs(translation.y) / 500;

    animator.setFractionComplete(factor);

    return;
  }
  if (recognizer.state === 'UIGestureRecognizerStateEnded') {
    const translation = recognizer.getTranslationInSuperiew();
    const factor = Math.abs(translation.y) / 500;

    if (factor > 0.5) {
      animator.continueAnimation();
    } else {
      animator.stopAnimation(true);
      if (!isOpen) {
        close();
      } else {
        open();
      }
    }

    return;
  }
};

const styles = StyleSheet.create({
  root: {
    flex: 1,
    backgroundColor: 'purple',
    position: 'relative',
  },
  anim: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: 'white',
    transform: [{translateY: 500}],
  },
});

export default App;
