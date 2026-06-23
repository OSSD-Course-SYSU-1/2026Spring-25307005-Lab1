/**
 * Global application context manager
 * Provides a way to access the AbilityContext from anywhere in the app,
 * which is required for distributed data operations.
 */

import { Context } from '@kit.AbilityKit';

class AppContextManager {
  private abilityContext: Context | null = null;

  /**
   * Set the global AbilityContext - should be called in Ability.onCreate()
   */
  setContext(context: Context): void {
    this.abilityContext = context;
  }

  /**
   * Get the global AbilityContext
   * Returns null if not set
   */
  getContext(): Context | null {
    return this.abilityContext;
  }
}

export default new AppContextManager();
